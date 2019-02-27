class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:intro, :wait, :choose, :turn, :play, :rate, :rated, :rating, :after_rating, :bestlist, :ended]
  before_action :authenticate_admin!, :set_admin, except: [:new, :create]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new
  end
    
  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      session[:game_session_id] = @game.id
      @admin = Admin.where(id: @game.admin_id, email: params[:admin][:email].downcase).first
      if @admin && @admin.valid_password?(params[:admin][:password])
        sign_in(@admin)
        redirect_to gma_new_avatar_path
      else
        flash[:danger] = "Unbekannte E-Mail / Password Kombination"
        redirect_to root_path
      end
    else
      flash[:danger] = "Konnte kein passende Siel finden"
      redirect_to root_path
    end
  end
    
  def new_avatar
  end
    
  def create_avatar
    @admin.update(avatar: params[:admin][:avatar])
    redirect_to gma_new_avatar_path
  end
    
  def new_turn
    @game = Game.find(session[:game_session_id])
    @turn = @game.turns.find_by(admin_id: @admin.id)
    if @turn
      redirect_to gma_intro_path
    end
  end
    
  def create_turn
    @game = Game.find(session[:game_session_id])
    @word = Word.all.sample(5).first
    @turn = Turn.new(play: params[:turn][:play], admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false)
    if @turn.save
      session.delete(:game_session_id)
      sign_in(@game)
      redirect_to gma_intro_path
    else
      redirect_to gma_new_turn_path
    end
  end
    
  def intro
    if @game.state == 'wait'
      redirect_to gma_wait_path
    end
  end
    
  def wait
    if @game.state == 'intro' || @game.state == 'replay'
      @game.update(state: 'wait')
    end
  end
    
  def choose
    @turns = @game.turns.playable.sample(100)
    if @turns.count == 1
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
    @turns = @game.turns.playable.sample(100)
    if @game.state != 'turn' && @turns.count == 1
      @game.update(state: 'turn', active: false, current_turn: @turns.first.id)
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
    if @turn.ratings.find_by(admin_id: @admin.id)
      redirect_to gma_rated_path
    elsif @admin == @cur_user
      redirect_to gma_rated_path
    end
  end
    
  def rated
    @ratings_count = @turn.ratings.count
    @player_count = @game.turns.count-1
  end
    
  def rating
    if @game.state != 'rating' && @turn.ratings.count == 0
      @turn.destroy
      redirect_to gma_after_rating_path
      return
    elsif @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
  end
    
  def after_rating
    @turns = @game.turns.playable.sample(100)
    if @turns.count == 1
      redirect_to gma_turn_path
      return
    elsif @turns.count == 0
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
    redirect_to root_path
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
    session[:game_session_id] = @game1.id
    redirect_to gma_new_turn_path
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
      @cur_user = @turn.findUser
    end
    
    def turn_params
      params.require(:turn).permit[:play]
    end
end
