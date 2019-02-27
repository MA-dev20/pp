class GameDesktopAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :ended]
  before_action :set_turn, only: [:turn, :play, :rate, :rating]
    
  layout 'game_desktop'

  def intro
  end
    
  def wait
    if @game.state == 'intro' || @game.state == 'replay'
        @game.update(state: 'wait')
    end
    @count = @game.turns.count
  end
    
  def choose
    @turns = @game.turns.playable.sample(100)
    if @turns.count == 1
      @game.update(active: false, current_turn: @turns.first.id)
      redirect_to gda_turns_path
      return
    elsif @turns.count == 0
      redirect_to gda_ended_path
      return
    elsif @game.state != 'choose'
      @game.update(active: false, current_turn: @turns.first.id, state: 'choose')
    end
  end

  def turn
    if @game.state != 'turn'
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
    if @game.turns.count == 1
      @game.turns.first.ratings.create(body: 0, creative: 0, rhetoric: 0, spontan: 0, ges: 0)
      redirect_to gda_rating_path
    end
  end
    
  def rating
    if @game.state != 'rating'
      @game.update(state: 'rating')
    end
    if @turn.ratings.count == 0
      @turn.destroy
      @game.update(state: 'choose')
      redirect_to gda_choose_path
    else
      @turn.update(played: true)
      update_turn_rating @turn
      update_user_rating @user
      @rating = @turn.turn_rating
    end
  end
    
  def after_rating
    @turns = @game.turns.playable.sample(100)
    if @turns.count == 1
      @game.update(current_turn: @turns.first.id)
      redirect_to gda_turn_path
    elsif @turns.count == 0
      redirect_to gda_bestlist_path
    else
      redirect_to gda_choose_path
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
    redirect_to dash_admin_path
  end
    
  def replay
    @game = current_game
    @admin = current_admin
    if @game.state != 'replay'
      @game.update(state: 'replay')
      @game1 = @admin.games.create(team_id: @game.team_id, state: 'wait', password: @game.password, active: true)
    else
      @game1 = @admin.games.where(team_id: @game.team_id, state: 'wait', password: @game.password, active: true).first
    end
    sign_out(@game)
    sign_in(@game1)
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
