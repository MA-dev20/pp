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
      @game.update(active:false, state: 'turn', current_turn: @turns.first.id)
      redirect_to gda_turn_path
      return
    elsif @turns.count == 0
      @game.update(active: false, state: 'bestlist')
      redirect_to gda_bestlist_path
      return
    elsif @game.state == 'wait' || @game.state == 'rating'
      @game.update(state: 'choose', active: false, current_turn: @turns.first.id)
      @turn = Turn.find_by(id: @game.current_turn)
      if !@turn.user_id.nil?
        @user = User.find_by(id: @turn.user_id)
      elsif !@turn.admin_id.nil?
        @user = Admin.find_by(id: @turn.admin_id)
      end
      @word = Word.find_by(id: @turn.word_id)
    end
  end

  def turn
    if @game.state == 'choose'
      @game.update(state: 'turn')
    end
  end
    
  def play
    if @game.state == 'turn'
      @game.update(state: 'play')
    end
  end
    
  def rate
    if @game.state == 'play'
      @game.update(state: 'rate')
    end
    if @game.turns.count == 1
      @game.turns.first.ratings.create(body: 0, creative: 0, rhetoric: 0, spontan: 0, ges: 0)
      redirect_to gda_rating_path
    end
  end
    
  def rating
    if @game.state == 'rate'
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
    
  def bestlist
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
    if @game = current_game
      @game.update(state: 'ended')
      sign_out(current_game)
    end
    redirect_to dash_admin_path
  end
    
  def replay
    if @game = current_game
      @admin = @game.admin
      @game1 = Game.where(password: @game.password, active: true).first
      @game.update(state:'replay')
      sign_out(@game)
      if !@game1
        @game1 = @admin.games.create(team_id: @game.team_id, state: 'wait', password: @game.password, active: true)
      end
      sign_in(@game1)
      redirect_to gda_wait_path
    else
      redirect_to root_path
    end
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
