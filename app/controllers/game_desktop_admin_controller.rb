class GameDesktopAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :ended, :ended_game]
  before_action :set_turn, only: [:play, :rate, :rating, :skip_rating]
  before_action :check_for_rating, only: [:rating]
    
  layout 'game_desktop'
	
  include GameSoundHelper
    
  def wait
    @handy = true
    if @game.state != 'wait'
        @game.update(state: 'wait')
    end 
    @users = @game.users
    @acc_users = @game.turns.where(status: "accepted").playable.all
    @count = @game.turns.where(status: "accepted").playable.count 
    @pending_users = @users.select{|user| user if user.status=="pending"}
  end
  
  def intro
	@turns = @game.turns.where(status: "accepted").playable.sample(2)
	if @turns.count <= 1
      redirect_to gea_turn_path
      return
	end
	if @game.youtube_url.present?
	  redirect_to gda_youtube_path
	  return
	elsif !@game.video.nil? && !@game.video_is_pitch
	  @video = Video.find_by(id: @game.video).file
	elsif !@game.video.nil? && @game.video_is_pitch
	  @video = Turn.find_by(id: @game.video).recorded_pitch
	end
	@game.update(active: false, state: 'intro')
  end
  
  def youtube_video
    @turns = @game.turns.where(status: "accepted").playable.sample(2)
    if @turns.count <= 1
      redirect_to gea_turn_path
      return
    else
      # @video_id = @game.youtube_url.split('/').last
      @video_url = @game.youtube_url
      ActionCable.server.broadcast "game_#{@game.id}_channel",desktop: "youtube_video", game_admin_id: @game.admin_id
    end
  end
    
  def choose
    @handy = true
    @turns = @game.turns.where(status: "accepted").playable.sample(2)
    if @game.state != 'choose'
      @turn1 = @turns.first
      @turn2 = @turns.second
      @game.update(active: false, turn1: @turn1.id, turn2: @turn2.id, state: 'choose')
    else
      @turn1 = Turn.find_by(id: @game.turn1)
      @turn2 = Turn.find_by(id: @game.turn2)
    end
  end

  def error 
  end

  def turn
    @turns = @game.turns.where(status: 'accepted').playable
    if @game.state != 'turn' && @turns.count == 1
      @turn = @turns.first
      @user = @turn.findUser
      @game.update(state: 'turn', active: false, current_turn: @game.turns.where(status: "accepted").playable.first.id)
    elsif @game.state != 'turn'
      @turn1 = Turn.find_by(id: @game.turn1)
      @turn2 = Turn.find_by(id: @game.turn2)
      if @turn1.counter > @turn2.counter
		@game.update(state: 'turn', current_turn: @turn1.id)
      else
        @game.update(state: 'turn', current_turn: @turn2.id)
      end
	  ActionCable.server.broadcast "game_#{@game.id}_channel",game_state: "turn", game_admin_id: @game.admin_id
    end
    @turn1 = Turn.find_by(id: @game.turn1)
    @turn2 = Turn.find_by(id: @game.turn2)
    @turn = Turn.find_by(id: @game.current_turn)
    @user = @turn.findUser
  end
    
  def play
	@peterswords = CatchwordsBasket.find_by(name: 'PetersWords')
    @video_toggle = @game.video_toggle
    if @game.state != 'play'
      @game.update(state: 'play')
    end
  end
    
  def rate
    @handy = true
    if @game.state != 'rate'
      @game.update(state: 'rate')
    end
  end
   
  def rating
    @custom_rating = @game.custom_rating
    @disabled_ratings_count = @turn.custom_rating_criteria.where(disabled: false).where.not(rating_criteria_id: nil).count / @custom_rating.rating_criteria.count
    if @game.state != 'rating' && @disabled_ratings_count == 0
      @turn.update(status: 'ended')
      redirect_to gda_after_rating_path
      return
    elsif @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
    update_turn_rating(@turn, @custom_rating)
    if @user != @admin
      update_user_rating(@user, @custom_rating, @game)
    end
    if @game.rating_user_id.present?
      @turn_rating_copy = User.find(@game.rating_user_id).custom_rating_criteria.where(game_id: @game.id, turn_id: @turn.id)
      @turn_rating = []
      @turn_rating_copy.each do |tr|
        @turn_rating << tr if tr.name != 'ges'
      end
      @turn_rating << @turn_rating_copy.where(name: 'ges').first
      unless @turn_rating_copy.present?
        # if @game.state != 'rate'
        #   @game.update(state: 'rate')
        # end
        # @game.update(state: 'turn')
        # redirect_to gda_after_rating_path
      end
    elsif @game.rating_option == 2
    else
      @turn_rating = @turn.turn_rating_criteria
    end
    # @rating = @turn.turn_rating
  end
  
  def skip_rating
    @custom_rating = @game.custom_rating
    @disabled_ratings_count = @turn.custom_rating_criteria.where(disabled: false).where.not(rating_criteria_id: nil).count / @custom_rating.rating_criteria.count
    if @game.state != 'rating' && @disabled_ratings_count == 0
      @turn.update(status: 'ended')
      redirect_to gda_after_rating_path
      return
    if @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
    update_turn_rating(@turn, @custom_rating)
    if @user != @admin
      update_user_rating(@user, @custom_rating, @game)
    end
    @rating = @turn.turn_rating
    
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
    if @turns.count == 1
      redirect_to gda_turn_path
      return
    elsif @turns.count == 0
      redirect_to gda_bestlist_path
      return
    else
      redirect_to gda_choose_path
      return
    end
  end

  def after_rating
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
    if @turns.count == 1
      redirect_to gda_turn_path
      return
    elsif @turns.count == 0
      redirect_to gda_bestlist_path
      return
    else
      if @game.rating_user_id.present?
        @game.update(state: 'choose')
      end
      redirect_to gda_choose_path
      return
    end
  end
    
  def bestlist
    if @game.state != 'bestlist'
      @game.update(state: 'bestlist')
    end
    update_game_rating(@game.custom_rating, @game)
    # update_team_rating @team
    # @turn_ratings = @game.turn_ratings.where(ended: false).rating_order
    update_team_rating(@team, @game)    
    @turn_ratings = @game.turn_rating_criteria.where(rating_criteria_id: nil, ended: false).order('value desc')
    place = 1
    @turn_ratings.each do |t|
        @turn = Turn.find(t.turn_id)
        @turn.update(place: place)
        place += 1
    end
  end

  def ended
    @game = current_game
    if @game.state != 'ended'
      @game.update(state: 'ended', active: false)
    end
    sign_out(@game)
    if @game.turns.where(status: "accepted").playable.count == 0
      # @game.destroy
    end
    redirect_to dash_admin_path
  end

  def ended_game
    @game = current_game
    if @game.state != 'ended_game'
      @game.update(state: 'ended_game', active: false)
    end
    sign_out(@game)
    if @game.turns.where(status: "accepted").playable.count == 0
      # @game.destroy
    end
    redirect_to dash_admin_path
  end


  def objection
    params[:objection]
    @current_admin = current_game.admin
    ActionCable.server.broadcast "admin_#{@current_admin.id}_channel", type: 'objection', url: params[:url],text: params[:objection]
  end
    
  def replay
    @game = current_game
    @admin = current_admin
    if @game.state != 'replay'
      @game.update(state: 'replay', active: true)
      @game.turn_ratings.update_all(ended: true)
      @game.turns.update_all(status: "ended")
      ids = @game.turns.pluck(:id)
      Rating.where('turn_id IN (?)',ids).update_all(disabled: true)
    else
      @game1 = @admin.games.where(team_id: @game.team_id, state: 'wait', password: @game.password, active: true).first
    end
    sign_in(@game)
    redirect_to gda_wait_path
  end

  def video_uploaded_status
    render json: @game.video_uploaded_start
  end
    
  private

    def set_vars
      @game = current_game
      @admin = current_admin
      @team = Team.find(@game.team_id)
      @state = @game.state
    end
    def set_turn
      @turn = Turn.find(@game.current_turn)
      @user = @turn.findUser
      @word = Word.find(@turn.word_id)
    end

    def check_for_rating
      if @game.rating_option == 2
        redirect_to gda_skip_rating_path
      elsif @game.rating_user_id.present?
        @turn = Turn.find_by(id: @game.current_turn)
        @cur_user = @turn.findUser if @turn
        @turn_rating_copy = User.find(@game.rating_user_id).custom_rating_criteria.where(game_id: @game.id, turn_id: @turn.id)
        unless @turn_rating_copy.present?
          redirect_to gda_skip_rating_path
        end
      end
    end
end
