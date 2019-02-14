class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :authenticate_admin!, :set_vars, except: [:replay, :new, :create]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
    def new
    end
    
    def create
      @game = Game.where(password: params[:password], active: true).first
      if @game
        sign_in(@game)
        @admin = Admin.where(id: @game.admin_id, email: params[:admin][:email].downcase).first
        if @admin && @admin.valid_password?(params[:admin][:password])
          sign_in(@admin)
          redirect_to gma_new_turn_path
        else
          flash[:danger] = "Unbekannte E-Mail / Password Kombination"
          redirect_to root_path
        end
      else
        flash[:danger] = "Konnte kein passende Siel finden"
        redirect_to root_path
      end
    end

    def redirect
    if @game.state == 'intro'
      @game.update(state: 'wait')
      redirect_to gma_wait_path
    elsif @game.state == 'wait' || @game.state == 'replay'
      @game.update(state: 'choose')
      redirect_to gma_choose_path
    elsif @game.state == 'choose'
      @game.update(state: 'turn')
      redirect_to gma_turn_path
    elsif @game.state == 'turn'
      @game.update(state: 'play')
      redirect_to gma_play_path
    elsif @game.state == 'play'
      @game.update(state: 'rate')
      redirect_to gma_rate_path
    elsif @game.state == 'rate'
      @game.update(state: 'rating')
      redirect_to gma_rating_path
    elsif @game.state == 'rating'
      @game.update(state: 'choose')
      redirect_to gma_choose_path
    end
  end
    
  def new_avatar
  end
    
  def create_avatar
    @admin.update(avatar: params[:admin][:avatar])
    redirect_to gma_new_avatar_path
  end
    
  def new_turn
    @turn = @game.turns.find_by(admin_id: @admin.id)
    if @admin.avatar.nil?
      redirect_to gma_new_avatar_path
    elsif @turn
      redirect_to gma_intro_path
    end
  end
    
  def create_turn
    @word = Word.all.sample(5).first
    @turn = Turn.new(play: params[:turn][:play], admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false)
    if @turn.save
      redirect_to gma_intro_path
    else
      redirect_to gma_new_turn_path
    end
  end
    
  def intro
  end
    
  def wait
  end
    
  def choose
  end
    
  def turn
  end
    
  def play
  end
    
  def rate
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
  end
    
  def bestlist
  end
    
  def ended
    @game.update(state: 'ended')
    sign_out(@admin)
    sign_out(@game)
    redirect_to root_path
  end
    
  def replay
    @game = Game.find(params[:game_id])
    @admin = Admin.find(params[:admin_id])
    @game.update(state: 'replay')
    @game1 = Game.where(password: @game.password, active: true).first
    if @game1
      sign_out(@game)
      sign_in(@game1)
      redirect_to gma_new_turn_path
    else
      @game1 = Game.create(admin_id: @admin.id, team_id: @game.team_id, active: true, state: 'intro', password: @game.password)
      sign_out(@game)
      sign_in(@game1)
      redirect_to gma_new_turn_path
    end
  end
    
  private
    def set_vars
      @admin = current_admin
      @game = current_game
      @team = Team.find(@game.team_id)
      @state = @game.state
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      @cur_user = @turn.findUser
    end
    
    def turn_params
      params.require(:turn).permit[:play]
    end
end
