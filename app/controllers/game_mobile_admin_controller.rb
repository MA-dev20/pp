class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:intro, :skip_rating, :choose_rating_user, :after_wait, :save_video,:wait, :choose, :choosen, :turn, :play, :react, :rate, :rated, :rating, :after_rating, :bestlist, :ended, :replay, :choose, :error, :welcome, :video_cancel, :youtube_video, :update_video_status]
  before_action :authenticate_admin!, :set_admin, except: [:new, :create, :password, :check_email, :video_testings, :ended_game]
  before_action :set_turn, only: [:play, :rate, :rated, :skip_rating, :rating, :save_video]
  before_action :check_for_rating, only: [:rating]
  layout 'game_mobile'
  skip_before_action :verify_authenticity_token, only: [:save_video]
    
  def new
    session[:admin_email] = nil
    @game1 = Game.where(password: params[:password], active: true).first
    session[:game_session_id] = @game1.id
  end

  def video_testing
    @cur_user = User.first
    @game1 = Game.first
    @turn  = Turn.first
    @record = true
  end

  def choose_rating_user
    @turns = @game.turns.where(status: "accepted").playable.sample(2)
    if @game.rating_option != 1 || @turns.count <= 1
      redirect_to gea_mobile_path
      return
    else
      @acc_turns = @game.turns.where(status: "accepted").playable.all
      @game.update(not_played_count: @acc_turns.count)
      @users = []
      @acc_turns.each do |turn|
        @users << turn.user if turn.user.present? 
      end
      @users.sort!{|a,b| a[:fname].downcase <=> b[:fname].downcase}
    end    
  end

  def after_wait
    if params[:user_id]
      @game.update(rating_user_id: params[:user_id].to_i)
    end
    redirect_to gma_intro_path
  end

  def password
    @game1 = Game.find(session[:game_session_id])
  end

  def video_cancel
    @game.video_uploading = false
    @game.save!
    render json: {response: "ok"}
  end

  def check_email
    session[:admin_email] = params[:admin][:email]
    redirect_to gma_pw_path
  end
 
  def save_video
    @game.update(video_uploading: false)
    @game.update(video_uploaded_start: false)
    @turn.recorded_pitch = params[:file]
    @turn.recorded_pitch_duration = params[:duration]
    @turn.save
    puts @turn.errors.messages
  end

  def create
    @game1 = Game.where(password: params[:password], active: true).first
    if @game1
      session[:game_session_id] = @game1.id
      @admin = Admin.where(id: @game1.admin_id, email: session[:admin_email].downcase).first
      if @admin && @admin.valid_password?(params[:admin][:password])
        sign_in(@admin)
        redirect_to gma_new_avatar_path
      else
        render :forget_pw
      end
    else
      session[:admin_email] = nil
      flash[:danger] = "Konnte keinen passenden Pitch finden"
      redirect_to root_path
    end
  end
    
  def new_avatar
    @game1 = Game.find(session[:game_session_id])
  end

  def update_game_seconds
    @game = Game.find(session[:game_session_id])
    @game.update(wait_seconds: params[:seconds])
    redirect_to gma_choose_path
  end

  def create_avatar
    @game1 = Game.find(session[:game_session_id])
    @admin.update(avatar: params[:admin][:avatar])
    redirect_to gma_new_avatar_path
  end
    
  def new_turn
    #Todo: sometimes session give nil value
    @game1 = Game.find(session[:game_session_id])
    @turn = @game1.turns.find_by(admin_id: @admin.id, admin_turn: true)
    @turn.update(status: 'ended') if @turn.present?
    params[:play] = params[:play] == 'rate' ? false : true
    create_turn_method(params[:play])
  end
    
  def create_turn
    create_turn_method(params[:turn][:play])
  end
    
  def intro
  @turns = @game.turns.where(status: "accepted").playable.sample(2)
	if !@game.video.nil?
		@video = true
	end
    if @game.state != 'choose' && @turns.count <= 1
      redirect_to gea_mobile_path
      return
    else
      ActionCable.server.broadcast "game_#{@game.id}_channel",desktop: "intro", game_admin_id: @game.admin_id
    end
  #Todo: new Task
  # @game.update(state: 'intro')
	@game.update(active: false, state: 'intro')
  end
    
  def wait
    if @game.state == 'intro' || @game.state == 'replay'
      @game.update(state: 'wait')
    end    
    @users = @game.users
    @count = @users.select{|user| user if user.status!="pending"}.count    
    @pending_users = @users.select{|user| user if user.status=="pending"}
  end
  
  def youtube_video
    @turns = @game.turns.where(status: "accepted").playable.sample(2)  
    if @game.state != 'choose' && @turns.count <= 1
      redirect_to gea_mobile_path
      return
    else
      ActionCable.server.broadcast "game_#{@game.id}_channel",desktop: "youtube_video", game_admin_id: @game.admin_id
    end    
    @users = @game.users
    @count = @users.select{|user| user if user.status!="pending"}.count    
    @pending_users = @users.select{|user| user if user.status=="pending"}
  end

  def choose
    @turns = @game.turns.where(status: "accepted").playable.sample(2)
    if (@game.rating_option == 1 || @game.rating_option == 2) && @game.choose_counter == 0
      @acc_turns = @game.turns.where(status: 'accepted').playable.all
      @game.update(not_played_count: @acc_turns.count, choose_counter: 1)
    end
    if @game.state != 'choose' && @turns.count <= 1
      redirect_to gea_mobile_path
      return
    elsif @game.state != 'choose'
      @turn1 = @turns.first
      @turn2 = @turns.second
      @game.update(active: false, turn1: @turn1.id, turn2: @turn2.id, state: 'choose')
      #Todo: new Task
      # @game.update(turn1: @turn1.id, turn2: @turn2.id, state: 'choose')
    else
      @turn1 = Turn.find_by(id: @game.turn1)
      @turn2 = Turn.find_by(id: @game.turn2)
    end
  end
    
  def choosen
    if params[:turn_id] == 'turn'
      redirect_to gma_turn_path
      return
    end
    @turn = Turn.find_by(id: params[:turn_id])
    @site = 'right'
    if @turn.id == @game.turn1
      @site = 'left'
    end
    @counter = @turn.counter + 1
    @turn.update(counter: @counter)
    ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'choosen', turn: @site, user_pic: @admin.avatar.quad.url
  end
    
  def turn
    @turns = @game.turns.where(status: 'accepted').playable
    if @game.state != 'turn' && @turns.count == 1
      @turn = @turns.first
      @game.update(state: 'turn', active: false, current_turn: @turn.id)
      #Todo: new task
      # @game.update(state: 'turn', current_turn: @turn.id)
    elsif @game.state != 'turn'
      @turn1 = Turn.find_by(id: @game.turn1)
      @turn2 = Turn.find_by(id: @game.turn2)
      if @turn1.counter > @turn2.counter
        @game.update(state: 'turn', current_turn: @turn1.id)
      else
        @game.update(state: 'turn', current_turn: @turn2.id)
      end
    end
    if @game.rating_option == 2
	    ActionCable.server.broadcast "game_#{@game.id}_channel",game_state: "turn", game_admin_id: @game.admin_id
    end
    @cur_user = Turn.find_by(id: @game.current_turn).findUser
  end
    
  def play
    if params[:video] == "true"
      @game.video_toggle = true
      session[:video_record] = params[:video]
    else
      @game.video_toggle = false
      session[:video_record] = params[:video]
    end
    if !params[:video].present?
      @game.video_toggle = false
      session[:video_record] = "false"
    end
    @record = eval session[:video_record] 
    @game.video_uploading = true if @record
    if params[:wait].present? && params[:wait] == "true"
      redirect_to "/mobile/admin/#{@game.state}" if @game.state != "play"
    else
      if @game.state != 'play'
        @game.state ='play'
        value = @game.not_played_count - 1
        @game.not_played_count = value
      end
    end
    @game.save!
  end

  def react
	@emoji = params[:emoji]
    ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'react', emoji: @emoji, user_pic: @admin.avatar.quad.url
	redirect_to gma_play_path('', reacted: 'true')
  end
    
  def rate
    if @game.state != 'rate'
      @game.state = 'rate'
    end
    @game.video_uploading = false
    @game.save
    @custom_rating = @game.custom_rating
    if @turn.custom_rating_criteria.find_by(admin_id: @admin.id)
      redirect_to gma_rated_path
    elsif @admin == @cur_user
      redirect_to gma_rated_path
    end
  end
    
  def rated
    @count = @turn.custom_rating_criteria.where.not(rating_criteria_id: nil).count / @game.custom_rating.rating_criteria.count
    @turnCount = @game.turns.where(status: "accepted").count - 1
    if @turn.ratings.count == @turnCount
      redirect_to gma_rating_path
    end
  end
    
  def rating
    @rating = CustomRatingCriterium.find_by(turn_id: @turn.id)
    if @rating && @game.state == 'rate'
      @game.update(state: 'rating')
      redirect_to gma_rating_path
      return
    elsif @game.state != 'rating' 
      @turn.update(status: "ended")
      redirect_to gma_after_rating_path
      return
    elsif @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
  end

  def skip_rating
    @rating = CustomRatingCriterium.find_by(turn_id: @turn.id)
    if @rating && @game.state == 'rate'
      @game.update(state: 'rating')
      redirect_to gma_skip_rating_path
      return
    elsif @game.state != 'rating'
      unless @turn.user.present?
        # current_admin.custom_rating_criteria.where(turn_id: @turn.id)
        @turn.update(played: true)
      end      
      @game.update(state: 'rating')
    end
    
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
    if @turns.count == 1
      redirect_to gma_turn_path
      return
    elsif @turns.count == 0 && @game.not_played_count == 0
      redirect_to gma_bestlist_path
      return
    else
      redirect_to gma_choose_path
      return
    end
  end
    
  def after_rating
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
    flag = true
    if @game.rating_user_id.present?
      flag = (@game.not_played_count == 0) ? true : false
    end
    if @turns.count == 1
      redirect_to gma_turn_path
      return
    elsif @turns.count == 0 && flag
      redirect_to gma_bestlist_path
      return
    else
      redirect_to gma_choose_path
      return
    end
  end
    
  def bestlist
    if @game.state != 'bestlist'
      @game.update(state: 'bestlist')
    end
  end
    
  def ended
    @game = current_game
    if @game.state != 'ended'
      @game.update(state: 'ended', active: false)
    end
    sign_out(@game)
    sign_out(@admin)
    redirect_to landing_ended_game_path
  end

  def ended_game
    @game = current_game
    if @game
      if @game.state != 'ended_game'
        @game.update(state: 'ended_game', active: false)
      end
      sign_out(@game)
      sign_out(@admin)
    end
    redirect_to landing_ended_game_path
  end
    
  def replay
    @game.replay = true
    @game.not_played_count = 0
    @game.choose_counter = 0
    @game.save!
    if @game.state != 'replay'
      @game.update(state: 'replay', active: true)
      @game.turns.update_all(status: "ended")
      @game.turn_rating_criteria.update_all(ended: true)
    end
    session[:game_session_id] = @game.id
    redirect_to gma_new_avatar_path
  end
    
  private

    def set_game
      @game = current_game
      @team = Team.find(@game.team_id)
      @state = @game.state
    end
    def set_admin
      @admin = current_admin
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      @cur_user = @turn.findUser if @turn
    end
    
    def turn_params
      params.require(:turn).permit[:play]
    end

    def create_turn_method(play=true)
      @game = Game.find(session[:game_session_id])
      sign_in(@game)
      if @game.own_words
        @word = @game.catchword_basket.words.sample(5).first if !@game.catchword_basket.nil?
        @word = CatchwordsBasket.find_by(name: 'PetersWords').words.all.sample(5).first if @word.nil?
        @word = Word.all.sample(5).first if @word.nil?
      else
        @word = CatchwordsBasket.find_by(name: 'PetersWords').words.all.sample(5).first if  CatchwordsBasket.find_by(name: 'PetersWords').present?
        @word = Word.all.sample(5).first if @word.nil?
      end
      @turn = Turn.where(admin_id: @admin.id, game_id: @game.id, played: false, status: "accepted", play: true, user_id: nil, admin_turn: true).first
      @turn = Turn.new(play: play, admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false, status: "accepted", admin_turn: true, counter: 0) if !@turn.present?
      if @turn.new_record? 
        @turn.save  
        @game.catchword_basket.words.delete(@word) if @game.uses_peterwords && @game.catchword_basket.present? && @game.catchword_basket.words.include?(@word)
        sign_in(@game)
        ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'true', counter: @game.turns.where(status: "accepted").playable.count.to_s, user_pic: @admin.avatar.quad.url, new: 'true'
        redirect_to gma_wait_path
      elsif @turn.present? 
        @game.catchword_basket.words.delete(@word) if @game.uses_peterwords && @game.catchword_basket.present? && @game.catchword_basket.words.include?(@word)
        sign_in(@game)
        ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'true', counter: @game.turns.where(status: "accepted").playable.count.to_s, user_pic: @admin.avatar.quad.url, new: 'true'
        redirect_to gma_wait_path
      else
        redirect_to gma_new_turn_path
      end
    end

    def check_for_rating
      if @game.rating_option == 2
        redirect_to gma_skip_rating_path
      elsif @game.rating_user_id.present?
        @turn = Turn.find_by(id: @game.current_turn)
        @cur_user = @turn.findUser if @turn
        @turn_rating_copy = User.find(@game.rating_user_id).custom_rating_criteria.where(game_id: @game.id, turn_id: @turn.id)
        unless @turn_rating_copy.present?
          redirect_to gma_skip_rating_path
        end
      end
    end
end

