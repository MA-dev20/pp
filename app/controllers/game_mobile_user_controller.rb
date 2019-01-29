class GameMobileUserController < ApplicationController
  before_action :require_game_user, :require_game, :set_vars, except: [:replay]
  before_action :set_turn, only: [:turn, :rate, :rated, :rating]
  layout 'game_mobile'
    
  def new_name
  end
    
  def create_name
    @user.update(user_params)
    redirect_to gmu_new_password_path
  end
    
  def new_password
  end
    
  def create_password
    @user.update(user_params)
    redirect_to gmu_new_company_path
  end
    
  def new_company
  end
    
  def create_company
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_avatar
  end
    
  def create_avatar
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_turn
    @turn = @game.turns.find_by(user_id: @user.id)
    if @turn
      redirect_to gmu_wait_path
    end
  end
    
  def create_turn
    @word = Word.all.sample(5).first
    @turn = Turn.new(user_id: @user.id, game_id: @game.id, word_id: @word.id, play: params[:turn][:play], played: false)
    if @turn.save
      redirect_to gmu_wait_path
    else
      redirect_to gmu_new_turn_path
    end
  end
    
  def wait
  end

  def choose
  end
    
  def turn
  end
    
  def rate
    if @user == @cur_user || @turn.ratings.find_by(user_id: @user.id)
        redirect_to gmu_rated_path
    end
  end
    
  def rated
  end
    
  def rating
  end
    
  def bestlist
  end
    
  def replay
    @game = Game.find(params[:game_id])
    @user = User.find(params[:user_id])
    @game1 = Game.where(password: @game.password, active: true).first
    game_logout
    game_login @game1
    game_user_login @user
    redirect_to gmu_new_turn_path
  end
    
  def ended
    game_logout
    redirect_to root_path
  end
    
  private
    def set_vars
      @user = current_game_user
      @game = current_game
      @state = @game.state
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      if !@turn.user_id.nil?
        @cur_user = User.find_by(id: @turn.user_id)
      else
        @cur_user = Admin.find_by(id: @turn.admin_id)
      end
    end
    
    def user_params
      params.require(:user).permit(:avatar, :company, :fname, :lname, :password)
    end
end
