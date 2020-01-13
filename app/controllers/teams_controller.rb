class TeamsController < ApplicationController
  before_action :authenticate, :set_admin
  before_action :set_team, only: [:destroy, :edit, :update]
 
  def create
    @team = @admin.teams.new(team_params)
    if @team.save
      if !params[:team][:users].nil?
        params[:team][:users].each do |u|
          @team.users << User.find_by(id: u)
        end
      end
      if params[:team][:url] == 'teams'
        redirect_to dash_admin_team_path(@team.id)
        return
      elsif !current_root.nil?
        redirect_to backoffice_edit_admin_path(@admin)
        return
      else
        redirect_to dash_admin_game_path(@team.id)
        return
      end
    elsif params[:name] == nil
      flash[:team_name] = 'Gib einen Namen an!'
    else
      flash[:danger] = 'Error'
    end
    if params[:team][:url] == 'teams'
      redirect_to dash_admin_teams_path
      return
    elsif !current_root.nil?
        redirect_to backoffice_edit_admin_path(@admin)
        return
    else
      redirect_to dash_admin_path
      return
    end
  end
 
  def update
    if @team.update(team_params)
      if params[:team][:users].nil?
        @team.team_users.each do |tu|
            tu.destroy
        end
      else
        @team.team_users.each do |tu|
            tu.destroy
        end
        params[:team][:users].each do |u|
          @team.users << User.find_by(id: u)
        end
      end
    elsif params[:team][:name] == nil
      flash[:team_name] = 'Gib einen Namen an!'
    else
      flash[:danger] = 'Error'
    end
    if params[:team][:site] == 'backoffice'
      redirect_to backoffice_edit_admin_path(@admin)
      return
    else
      redirect_to dash_admin_team_path(@team.id)
      return
    end
  end
    
  def destroy
    @team.games.each do |g|
      if g.catchword_basket
        g.catchword_basket.destroy
      end
    end
    if !@team.destroy
      flash[:danger] = 'Team NICHT gelöscht!'
      redirect_to dash_admin_teams_path
    end
    if !current_root.nil?
      redirect_to backoffice_edit_admin_path(@team.admin)
      return
    else
      redirect_to dash_admin_teams_path
      return
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
    def set_admin
      if !current_admin.nil?
        @admin = current_admin
      elsif !current_root.nil?
        @admin = Admin.find(params[:team][:admin_id])
      end
    end
    
    def set_team
      @team = Team.find(params[:team_id])
    end
    
    def team_params
      params.require(:team).permit(:name)
    end
end
