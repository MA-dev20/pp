class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate
  before_action :set_user, only: [:update, :destroy]
    
  def create
    if user_params[:email].empty?
      flash[:user_email] = 'Gib eine E-Mail an!'
    elsif !Admin.find_by(email: user_params[:email]).nil? || !User.find_by(email: user_params[:email]).nil?
      flash[:user_email] = 'Schon vergeben!'
    end
    if !user_params[:email].empty? || Admin.find_by(email: user_params[:email]).nil? || User.find_by(email: user_params[:email]).nil?
      @random_pass = random_pass
      @user = User.new(user_params)
      @user.password = @random_pass
      if @user.save
		AdminMailer.after_activate(@user, @random_pass).deliver
	  else
		flash[:danger] = "Konnte User nicht erstellen"
	  end
      if params[:user][:teams].present?
        @user.teams.destroy_all
        params[:user][:teams].each do |t|
          @user.teams << Team.find_by(id: t)
        end
      else
        @user.teams.destroy_all
      end
    end
    if !current_root.nil?
      redirect_to backoffice_edit_user_path(@user)
    else
      redirect_to dash_admin_teams_path
    end
  end
    
  def update
    @user = User.find(params[:user_id])
    @user.update(user_params)
    team_ids = @user.team_ids.map(&:to_s)
    if params[:user][:teams].present?
      @user.teams.destroy_all
      params[:user][:teams].each do |t|
        @user.teams << Team.find_by(id: t)
      end
    else
      @user.teams.destroy_all
    end
    if !current_root.nil?
      redirect_to backoffice_edit_admin_path(@admin)
      return
    else
      redirect_to dash_admin_user_path(@user)
      return
    end
  end
    
  def destroy
    if !@user.destroy
      flash[:danger] = 'Konnte Spieler nicht löschen!'
    end
    if !current_root.nil?
      redirect_to backoffice_edit_admin_path(@admin)
    else
      redirect_to dash_admin_teams_path
    end
  end

  private
    def authenticate
      if current_admin.nil? && current_root.nil?
          flash[:danger] = "Bitte logge dich ein!"
          redirect_to new_session_path(admin)
          return
      end
    end
    def set_user
      @user = User.find(params[:user_id])
	  if !current_admin.nil?
        @admin = current_admin
      else
        @admin = Admin.find(@user.admin_id)
      end
    end

    def user_params
      params.require(:user).permit(:fname, :lname, :company_name, :email, :avatar, :admin_id )
    end
end
