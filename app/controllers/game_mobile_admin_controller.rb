class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:intro, :wait, :choose, :turn, :play, :rate, :rated, :rating, :bestlist, :ended]
  before_action :authenticate_admin!, :set_admin, except: [:new, :create]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new
  end
    
  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      session[:game_id] = @game.id
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
    @game = Game.find(session[:game_id])
    @turn = @game.turns.find_by(admin_id: @admin.id)
    if @turn
      redirect_to gma_intro_path
    end
  end
    
  def create_turn
    @game = Game.find(session[:game_id])
    @word = Word.all.sample(5).first
    @turn = Turn.new(play: params[:turn][:play], admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false)
    if @turn.save
      session.delete(:game_id)
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
    if @game.state == 'wait' || @game.state == 'rating'
      @game.update(state: 'choose')
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
    if @game.state == 'rate'
      @game.update(state: 'rating')
    end
  end
    
  def bestlist
  end
    
  def ended
    if @game.state == 'bestlist'
      @game.update(state: 'ended')
    end
    sign_out(@game)
    sign_out(@admin)
    redirect_to root_path
  end
    
  def replay
    @game = current_game
    if @game.state == 'bestlist'
      @game.update(state: 'replay')
    end
    @admin = @game.admin
    @game1 = @admin.games.where(password: @game.password, active: true).first
    sign_out(@game)
    session[:game_id] = @game1.id
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
