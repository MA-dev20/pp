class GameDesktopAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :ended]
  before_action :set_turn, only: [:turn, :play, :rate, :rating]
    
  layout 'game_desktop'

  def intro
  end
    
  def wait
    if @game.state != 'wait'
        @game.update(state: 'wait')
    end 
    @users = @game.users
    @count = @users.select{|user| user if user.status!="pending"}.count    
    @pending_users = @users.select{|user| user if user.status=="pending"}
  end
    
  def choose
    @turns = @game.turns.playable.sample(100)
    if @game.state != 'choose' && @turns.count == 1
      redirect_to gea_turn_path
      return
    elsif @game.state != 'choose' && @turns.count == 0
      redirect_to gea_turn_path
      return
    elsif @game.state != 'choose'
      if @game.turns.count > 1
        @game.update(active: false, current_turn: @turns.first.id, state: 'choose')
      else
        redirect_to gea_turn_path
      end
    end
  end

  def error
    
  end

  def turn
    if @game.state != 'turn' && @game.turns.playable.count == 1
      @turn = @game.turns.playable.first
      @game.update(state: 'turn', active: false, current_turn: @game.turns.playable.first.id)
    elsif @game.state != 'turn'
      @game.update(state: 'turn')
    end
  end
    
  def play
    if @game.state != 'play'
      @game.update(state: 'play')
    end
  end
    
  def rate
    if @game.state != 'rate'
      @game.update(state: 'rate')
    end
  end
    
  def rating
    if @game.state != 'rating' && @turn.ratings.count == 0
      @turn.destroy
      redirect_to gda_after_rating_path
      return
    elsif @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
    update_turn_rating @turn
    update_user_rating @user
    @rating = @turn.turn_rating
  end
    
  def after_rating
    @turns = @game.turns.playable.sample(100)
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
    
  def bestlist
    if @game.state != 'bestlist'
      @game.update(state: 'bestlist')
    end
    update_game_rating @game
    update_team_rating @team
    @turn_ratings = @game.turn_ratings.rating_order
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
    if @game.turns.count == 0
      @game.destroy
    end
    redirect_to dash_admin_path
  end

  def objection
    params[:objection]
    @current_admin = current_game.admin
    ActionCable.server.broadcast "admin_#{@current_admin.id}_channel", type: 'objection', text: params[:objection]
  end
    
  def replay
    @game = current_game
    @admin = current_admin
    if @game.state != 'replay'
      @game.update(state: 'replay', active: true)
      @game.turns.destroy_all
    else
      @game1 = @admin.games.where(team_id: @game.team_id, state: 'wait', password: @game.password, active: true).first
    end
    sign_in(@game)
    redirect_to gda_wait_path
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
end
