class GameDesktopAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :ended]
  before_action :set_turn, only: [:play, :rate, :rating]
    
  layout 'game_desktop'

  def intro
  end
    
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
    
  def choose
    @handy = true
    @turns = @game.turns.where(status: "accepted").playable.sample(2)
    if @turns.count <= 1
      redirect_to gea_turn_path
      return
    elsif @game.state != 'choose'
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
    end
    @turn1 = Turn.find_by(id: @game.turn1)
    @turn2 = Turn.find_by(id: @game.turn2)
    @turn = Turn.find_by(id: @game.current_turn)
    @user = @turn.findUser
  end
    
  def play
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
    if @game.state != 'rating' && @turn.ratings.where(disabled: false).count == 0
      @turn.update(status: 'ended')
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
    
  def bestlist
    if @game.state != 'bestlist'
      @game.update(state: 'bestlist')
    end
    update_game_rating @game
    update_team_rating @team
    @turn_ratings = @game.turn_ratings.where(ended: false).rating_order
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
