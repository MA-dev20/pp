class GameMobileAdminController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:intro, :wait, :choose, :turn, :play, :rate, :rated, :rating, :after_rating, :bestlist, :ended, :replay]
  before_action :authenticate_admin!, :set_admin, except: [:new, :create, :password, :check_email]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new
    session[:admin_email] = nil
    @game = Game.where(password: params[:password], active: true).first
    session[:game_session_id] = @game.id
    sign_in(@game)
  end

  def password
  end

  def check_email
    session[:admin_email] = params[:admin][:email]
    redirect_to gma_pw_path
  end

  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      session[:game_session_id] = @game.id
      sign_in(@game)
      @admin = Admin.where(id: @game.admin_id, email: session[:admin_email].downcase).first
      if @admin && @admin.valid_password?(params[:admin][:password])
        flash[:success] = "Successfully signed In"
        sign_in(@admin)
        redirect_to gma_new_avatar_path
      else
        flash[:danger] = "Unbekannte E-Mail / Password Kombination"
        render :forget_pw
      end
    else
      session[:admin_email] = nil
      flash[:danger] = "Konnte kein passende Spiel finden"
      redirect_to root_path
    end
  end
    
  def new_avatar
    @game = Game.find(session[:game_session_id])
  end

  def update_game_seconds
    @game = Game.find(session[:game_session_id])
    @game.update(wait_seconds: params[:seconds])
    redirect_to gma_choose_path
  end

  def create_avatar
    @game = Game.find(session[:game_session_id])
    @admin.update(avatar: params[:admin][:avatar])
    redirect_to gma_new_avatar_path
  end
    
  def new_turn
    @game = Game.find(session[:game_session_id])
    @turn = @game.turns.find_by(admin_id: @admin.id, admin_turn: true)
    @turn.update(status: 'ended') if @turn.present?
    # if @turn
    #   redirect_to gma_intro_path
    # end
  end
    
  def create_turn
    @game = Game.find(session[:game_session_id])
    if @game.own_words
      @word = @game.has_or_create_basket_for_words.words.sample(5).first
      @word = Word.all.sample(5).first if @word.nil?
    else
      @word = Word.all.sample(5).first
    end
    @turn = Turn.new(play: params[:turn][:play], admin_id: @admin.id, game_id: @game.id, word_id: @word.id, played: false, status: "accepted", admin_turn: true)
    if @turn.save
      sign_in(@game)
      ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'true', counter: @game.turns.where(status: "accepted").playable.count.to_s
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
    @users = @game.users
    @count = @users.select{|user| user if user.status!="pending"}.count    
    @pending_users = @users.select{|user| user if user.status=="pending"}
  end
    
  def choose
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
    if @game.state != 'choose' && @turns.count == 1
      redirect_to gea_mobile_path
      return
    elsif  @game.state != 'choose' && @turns.count == 0
      redirect_to gea_mobile_path
      return
    elsif @game.state != 'choose'
      if @game.turns.where(status: "accepted").count > 1
        @game.update(active: false, current_turn: @turns.first.id, state: 'choose')
      else
        redirect_to gea_mobile_path
      end
    end
  end
    
  def turn
    if @game.state != 'turn' && @game.turns.where(status: "accepted").playable.count == 1
      @turn = @game.turns.where(status: "accepted").playable.first
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
    if @turn.ratings.find_by(admin_id: @admin.id)
      redirect_to gma_rated_path
    elsif @admin == @cur_user
      redirect_to gma_rated_path
    end
  end
    
  def rated
    @count = @turn.ratings.count.to_s + '/' + (@game.turns.where(status: "accepted").playable.count - 1).to_s + ' haben bewertet!'
    if @turn.ratings.count == @game.turns.where(status: "accepted").playable.count - 1
      redirect_to gma_rating_path
    end
  end
    
  def rating
    if @game.state != 'rating' && @turn.ratings.count == 0
      @turn.update(status: "ended")
      redirect_to gma_after_rating_path
      return
    elsif @game.state != 'rating'
      @turn.update(played: true)
      @game.update(state: 'rating')
    end
  end
    
  def after_rating
    @turns = @game.turns.where(status: "accepted").playable.sample(100)
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
    @admin = current_admin
    @game = current_game
    if @game.state != 'replay'
      @game.update(state: 'replay', active: true)
      @game.turns.update_all(status: "ended")
    end
    session[:game_session_id] = @game.id
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
      @cur_user = @turn.findUser if @turn
    end
    
    def turn_params
      params.require(:turn).permit[:play]
    end
end
