class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_admin!, :set_vars, except: [:create]

    
  def new
  end
    
  def create
    if user_params[:email].empty?
      flash[:user_email] = 'Gib eine E-Mail an!'
    elsif !Admin.find_by(email: user_params[:email]).nil? || !User.find_by(email: user_params[:email]).nil?
      flash[:user_email] = 'Schon vergeben!'
    end
    if user_params[:email].empty? || !Admin.find_by(email: user_params[:email]).nil? || !User.find_by(email: user_params[:email]).nil?
      redirect_to dash_admin_teams_path
      return
    end
    @random_pass = random_pass
    @user = User.new(user_params)
    @user.encrypted_pw = @user.encrypt @random_pass
    @user.save
    if params[:user][:teams].present?
      @user.teams.destroy_all
      params[:user][:teams].each do |t|
        @user.teams << Team.find_by(id: t)
      end
    else
      @user.teams.destroy_all
    end
    if @user.save
      SendInvitationJob.perform_later(@user, @random_pass)
    else
      flash[:danger] = "Konnte User nicht erstellen"
    end
    redirect_to dash_admin_teams_path
  end
    
  def edit
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
    redirect_to dash_admin_user_path(@user)
  end
    
    
  def destroy
    if @user.destroy
      redirect_to dash_admin_teams_path
    else
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      redirect_to dash_admin_users_path
    end
  end
  
  


  
  private
    def set_vars
      @admin = current_admin
      @user = User.find(params[:user_id])
    end

    def user_params
      params.require(:user).permit(:fname, :lname, :company_name, :email, :avatar, :admin_id )
    end
end
