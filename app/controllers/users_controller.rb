class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_admin!, :set_vars, except: [:create]

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

  def create
    @user = User.new(user_params)
    if Admin.find_by_email(user_params[:email]).present?
      @user.errors.messages[:email].push("You can't use this email")
      respond_to do |format|
        format.js do
          render :create
        end
      end
    else
      @user.admin_id = current_admin.id
      @random_pass = random_pass
      @user.encrypted_pw = @user.encrypt @random_pass
      if @user.save
        SendInvitationJob.perform_later(@user, @random_pass)
        if params[:user][:teams].present?
          @user.team_ids = params[:user][:teams] 
        else
          @user.teams.destroy_all
        end
        redirect_to dash_admin_users_path
      else
        respond_to do |format|
          format.js do
            render :create
          end
        end
      end
    end
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
