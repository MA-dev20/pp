class GameMobileUserController < ApplicationController
  before_action :authenticate_game!, :set_game, only: [:wait, :choose, :turn, :play, :rate, :rated, :rating, :bestlist, :ended, :reject_user ,:accept_user]
  before_action :authenticate_user!, :set_user, except: [:welcome, :new, :create,:reject_user ,:accept_user]
  before_action :set_turn, only: [:turn, :play, :rate, :rated, :rating]
  # before_action :pop_up ,only: :create
  before_action :reset_session_of_already_user, only: [:new, :welcome]
  layout 'game_mobile'

    
  def welcome
    @game1 = Game.where(password: params[:password], active: true).first
    if @game1
      session[:game_session_id] = @game1.id
    else
      flash[:danger] = 'Konnte kein passendes Spiel finden!'
      redirect_to root_path
    end
  end
    
  def new
    @game1 = Game.find(session[:game_session_id])
    if !@game1
      flash[:danger] = 'Konnte kein passendes Spiel finden!'
      redirect_to root_path
    end
  end
    
  def create
    @game1 = Game.find(session[:game_session_id])
    if @game1
      @admin = Admin.find(@game1.admin_id)
      if @admin.email == params[:user][:email].downcase
        redirect_to gma_start_path(@game1.password)
        return
      end
      @user = User.find_by(email: params[:user][:email])
      if @user && @user.admin == @admin
        if TeamUser.where(user_id: @user.id, team_id: @game1.team_id).count == 0
          TeamUser.create(user_id: @user.id, team_id: @game1.team_id)
        end
        session[:user_already] = true
        sign_in(@user)
        redirect_to gmu_new_avatar_path
      else
        session[:user_already] = nil
        @user = @admin.users.create(email: params[:user][:email])
        TeamUser.create(user_id: @user.id, team_id: @game1.team_id)
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
      @turn = Turn.where(user_id: @user.id).destroy_all
      TurnRating.where(user_id:  @user.id).destroy_all
      TeamUser.where(user_id: @user.id).destroy_all
      @user.destroy
      if @user
        ActionCable.server.broadcast  "count_#{@game.id}_channel", count: 'true', counter: @game.turns.count.to_s, modal: false,  user_id: params[:user_id]
      else
        ActionCable.server.broadcast  "count_#{@game.id}_channel", count: 'true', counter: @game.turns.count.to_s, modal: false,  user_id: params[:user_id]
      end
      respond_to do |format|
        format.js {render :js => "$('#myModalAction#{params[:user_id]}').hide()"}
        format.html {redirect_back(fallback_location: root_path) and return}
      end
    end
  end


  def accept_user
    Stripe.api_key = 'sk_test_zPJA7u8PtoHc4MdDUsTQNU8g'

    @user = User.where(id: params[:user_id]).first
    @admin = Admin.find(@game.admin_id)
    session[:user_already] = true
    a =8.85*100
    month =a.to_i
    if @admin.plan_type.eql?('trial')
      @user.update_attributes(status: 0)
      create_turn_against_user(@user, @admin)
      # return
      ActionCable.server.broadcast  "count_#{@game1.id}_channel", count: 'true', counter: @game.users.where.not(status: "pending").count.to_s, modal: false, user_id: params[:user_id]
      respond_to do |format|
        format.js {render :js => "$('#myModalAction#{params[:user_id]}').hide()"}
        format.html {redirect_back(fallback_location: root_path) and return}
      end
      return
    elsif @admin.plan_users?
      @user.update_attributes(status: 'accepted')
      create_turn_against_user(@user, @admin)
      ActionCable.server.broadcast  "count_#{@game1.id}_channel", count: 'true', counter: @game.users.where.not(status: "pending").count.to_s, modal: false, user_id: params[:user_id]
      if((@game.turns.select{|turn| turn if !turn.user.nil? && turn.user.accepted?}.count) > @admin.plan_users )
        if @user.admin.plan_type.eql?("year")
          @admin.update_attributes(plan_users: @admin.plan_users + 1 )
          @user.admin.upgrade_subscription_year(@user)
          respond_to do |format|
            format.js {render :js => "$('#myModalAction#{params[:user_id]}').hide()"}
            format.html {redirect_back(fallback_location: root_path) and return}
          end
          return
        elsif @user.admin.plan_type.eql?("month")
          @admin.update_attributes(plan_users: @admin.plan_users + 1 )
          Stripe::Charge.create({
                                    customer:@admin.stripe_id ,
                                    amount: month,
                                    currency: 'eur',
                                    description: 'Charge for PeterPitch  ' + @user.email,
                                })
          @admin.upgrade_subscription
           respond_to do |format|
            format.js {render :js => "$('#myModalAction#{params[:user_id]}').hide()"}
            format.html {redirect_back(fallback_location: root_path) and return}
          end
          return
        end
      end
      respond_to do |format|
        format.js {render :js => "$('#myModalAction#{params[:user_id]}').hide()"}
        format.html {redirect_back(fallback_location: root_path) and return}
      end
      return

    end
  end


  def new_name
    @game1 = Game.find(session[:game_session_id])
  end

  def create_name
    @game1 = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_company_path
  end
    
  def new_company
    @game1 = Game.find(session[:game_session_id])
  end
     
  def create_company
    @game1 = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_avatar
    @game1 = Game.find(session[:game_session_id])
  end

  def create_avatar
    @game1 = Game.find(session[:game_session_id])
    @user.update(user_params)
    redirect_to gmu_new_avatar_path
  end
    
  def new_turn
    @game1 = Game.find(session[:game_session_id])
    @turn = @game1.turns.find_by(user_id: @user.id)
    if @turn
       sign_in(@game1)
       redirect_to send("gmu_"+@game1.state+"_path")
    end
  end
    
  def create_turn
    @game1 = Game.find(session[:game_session_id])
    @admin = @game1.admin
    @game = @game1
    @word = Word.first(50).sample(5).first if @game1.admin.admin_subscription_id.nil?
    @word = Word.all.sample(5).first if @word.nil?
    if @game1.active
      session.delete(:game_session_id)
      sign_in(@game1)
      if session[:user_already]
        create_turn_against_user(current_user, @admin)
        ActionCable.server.broadcast "count_#{@game1.id}_channel", count: 'true', counter: @game1.users.where.not(status: "pending").count.to_s
      else
        create_turn_against_user(current_user, @admin)
        ActionCable.server.broadcast "count_#{@game1.id}_channel", count: 'true', counter: @game1.users.where.not(status: "pending").count.to_s
      end
      redirect_to gmu_wait_path
    else
      flash[:danger] = 'Das Spiel ist schon beendet!'
      redirect_to root_path
    end
  end


    
  def wait
    @admin = Admin.find(@game.admin_id)
    turn =  Turn.where(user_id:  current_user.id, game_id:  @game.id, admin_id: @admin.id).first
    if (!turn.nil?) 
      if current_user.status == "pending"
        ActionCable.server.broadcast "count_#{@game.id}_channel", count: 'wait-user', game_state: 'wait' ,game_id: current_game.id, counter: @game.users.where.not(status: "pending").count.to_s, 
        user_fname: current_user.fname, user_lname: current_user.lname,
        user_avatar: current_user.avatar.url , user_id: current_user.id
      end
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
    session[:game_session_id] = @game.id
    # redirect_to gmu_new_turn_path
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

    def create_turn_against_user(user, admin)
      @game1 = current_game
      @word = Word.first(50).sample(5).first if @game1.admin.admin_subscription_id.nil?
      @word = Word.all.sample(5).first if @word.nil?
      turn =  Turn.where(user_id:  user.id, game_id:  @game.id, admin_id: admin.id).first
      @turn = Turn.new(user_id: user.id, game_id: @game1.id, word_id: @word.id, play: true, played: false, admin_id: admin.id)
      @turn.save! if turn.nil?
    end

    def reset_session_of_already_user
      session[:user_already] = nil
    end


end
