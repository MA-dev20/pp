class UsersController < ApplicationController
  before_action :authenticate_admin!, :set_vars

  def destroy
    if @user.destroy
      flash[:success] = 'Spieler erfolgreich gelöscht!'
      redirect_to dash_admin_users_path
    else
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      redirect_to dash_admin_users_path
    end
  end
  
  def update
    @user = User.find(params[:user_id])
    @user.update(user_params)
    team_ids = @user.team_ids.map(&:to_s)
    if params[:user][:teams].present?
      @user.team_ids = params[:user][:teams] 
    else
      @user.teams.destroy_all
    end
    redirect_to dash_admin_users_path
  end
  
  private
    def set_vars
      @admin = current_admin
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:user).permit(:fname,:lname, :company_name, :email, :avatar )
    end
end
