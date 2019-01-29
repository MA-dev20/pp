class GameSessionController < ApplicationController
    
  def new
  end
    
  def create
    @game = Game.where(password: params[:session][:password], active: true).first
    @user = User.find_by(email: params[:session][:email].downcase)
    if @game
      @admin = Admin.find(@game.admin_id)
      if @user
        if @user.admin_id == @admin.id
          game_login @game
          game_user_login @user
          redirect_to gmu_new_turn_path
        else
          flash[:danger] = 'Du bist schon bei einem anderen Admin registriert!'
          redirect_to root_path
        end
      elsif @admin.email == params[:session][:email].downcase
        game_login @game
        game_admin_login @admin
        redirect_to gma_new_turn_path
      else
        game_login @game
        @user = User.create(admin_id: @admin.id, email: params[:session][:email])
        @teamuser = TeamUser.create(team_id: @game.team_id, user_id: @user.id)
        game_user_login @user
        redirect_to gmu_new_name_path
      end
    else
      flash[:danger] = 'Konnte kein passendes Spiel finden'
      redirect_to root_path
    end
  end
    
  def destroy
  end
end
    