class GameMobileUserController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:wait, :choose, :turn, :play, :rate, :rated, :rating, :bestlist, :ended, :reject_user ,:accept_user]
  before_action :authenticate_user!, :set_user, except: [:new, :create,:reject_user ,:accept_user]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  # before_action :pop_up ,only: :create
  layout 'game_mobile'

  def new
    @game = Game.where(password: params[:password], active: true).first
  end
    
  def create
    @game = Game.where(password: params[:password], active: true).first
    if @game
      session[:game_session_id] = @game.id
      @admin = Admin.find(@game.admin_id)
      if @admin.email == params[:user][:email].downcase
        redirect_to gma_start_path(params[:password])
        return
      end
      @user = User.find_by(email: params[:user][:email])
      if @user && @user.admin == @admin
        if TeamUser.where(user_id: @user.id, team_id: @game.team_id).count == 0
          TeamUser.create(user_id: @user.id, team_id: @game.team_id)
        end
        sign_in(@user)
        redirect_to gmu_new_avatar_path
      else
        @user = @admin.users.create(email: params[:user][:email])
        TeamUser.create(user_id: @user.id, team_id: @game.team_id)
        sign_in(@user)
        redirect_to gmu_new_name_path
      end
    else
      flash[:danger] = 'Konnte kein passendes Spiel finden!'
      redirect_to root_path
    end
  end

  def reject_user
    @user = User.where(id: params[:user_id]).first
    if @user.update_attributes(status: 1)
      redirect_back(fallback_location: root_path)
      Turn.where(user_id: @user.id).first.delete
      ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'false' , game_id: current_game.id, user_fname: @user.lname, user_lname: @user.fname, user_password: @game.password, status: @user.status
    end
  end


  def accept_user
    Stripe.api_key = 'sk_test_zPJA7u8PtoHc4MdDUsTQNU8g'

    @user = User.where(id: params[:user_id]).first
    @admin = Admin.find(@game.admin_id)

    a =8.85*100
    month =a.to_i

    if @admin.plan_type.eql?('trial')
      @user.update_attributes(status: 0)
      redirect_back(fallback_location: root_path)  and return
    elsif @admin.plan_users?
      @user.update_attributes(status: 'accepted')
      if((@game.turns.select{|turn| turn if !turn.user.nil? && turn.user.accepted?}.count) > @admin.plan_users )
        if @user.admin.plan_type.eql?("year")
          @admin.update_attributes(plan_users: @admin.plan_users + 1 )
          @user.admin.upgrade_subscription_year(@user)
          redirect_back(fallback_location: root_path)  and return
        elsif @user.admin.plan_type.eql?("month")
          @admin.update_attributes(plan_users: @admin.plan_users + 1 )
          Stripe::Charge.create({
                                    customer:@admin.stripe_id ,
                                    amount: month,
                                    currency: 'eur',
                                    description: 'Charge for PeterPitch  ' + @user.email,
                                })
          @admin.upgrade_subscription
          redirect_back(fallback_location: root_path)  and return
        end
      end
      redirect_back(fallback_location: root_path) and return

    end
  end


  def new_name
    @game = Game.find(session[:game_session_id])
  end

  def create_name
    @game = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_company_path
  end
    
  def new_company
    @game = Game.find(session[:game_session_id])
  end
     
  def create_company
    @game = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_avatar
    @game = Game.find(session[:game_session_id])
  end

  def create_avatar
    @game = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_turn
    @game = Game.find(session[:game_session_id])
    @turn = @game.turns.find_by(user_id: @user.id)
    if @turn
      redirect_to gmu_wait_path
    end
  end
    
  def create_turn
    @game = Game.find(session[:game_session_id])
    @word = Word.all.sample(5).first
    @turn = Turn.new(user_id: @user.id, game_id: @game.id, word_id: @word.id, play: params[:turn][:play], played: false)
    if @turn.save
      session.delete(:game_session_id)
      sign_in(@game)
      ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'true', counter: @game.turns.count.to_s
      redirect_to gmu_wait_path
    else
      redirect_to gmu_new_turn_path
    end
  end


    
  def wait
    @admin = Admin.find(@game.admin_id)
    if (current_user && current_user.admin == @admin )&& (current_user.status== "pending" || current_user.status== "rejected" )
      ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'false', game_state: 'wait' ,game_id: current_game.id, counter: @game.turns.count.to_s, 
      user_fname: current_user.fname, user_lname: current_user.lname,
      user_avatar: current_user.avatar.url , user_id: current_user.id
    end

  end
    

  def choose
  end
    
  def turn
  end
    
  def play
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
    @turn_rating = @game.turn_ratings.where(user_id: @user.id).first
  end
    
  def replay
    @game = current_game
    @admin = Admin.find(@game.admin_id)
    @game1 = @admin.games.where(password: @game.password, active: true).first
    sign_out(@game)
    session[:game_session_id] = @game1.id
    redirect_to gmu_new_turn_path
  end
    
  def ended
    sign_out(@game)
    sign_out(@user)
    redirect_to root_path
  end
    
  private
    def set_game
      @game = current_game
      @state = @game.state
    end
    def set_user
      @user = current_user
    end
    
    def set_turn
      @turn = Turn.find_by(id: @game.current_turn)
      @cur_user = @turn.findUser
    end
    
    def user_params
      params.require(:user).permit(:avatar, :company, :fname, :lname)
    end


end
