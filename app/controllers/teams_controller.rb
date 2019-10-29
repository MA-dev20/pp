class TeamsController < ApplicationController
  before_action :authenticate_admin!, :set_admin
  before_action :set_team, only: [:destroy, :edit, :update]

  def new
  end
    
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
    else
      redirect_to dash_admin_path
      return
    end
  end
    
  def edit
  end
    
  def update
    if @team.update(team_params)
      if params[:team][:users].nil?
        @team.team_users.each do |tu|
            tu.destroy
        end
        redirect_to dash_admin_team_path(@team.id)
      else
        @team.team_users.each do |tu|
            tu.destroy
        end
        params[:team][:users].each do |u|
          @team.users << User.find_by(id: u)
        end
        redirect_to dash_admin_team_path(@team.id)
      end
    elsif params[:name] == nil
      flash[:team_name] = 'Gib einen Namen an!'
      redirect_to dash_admin_teams_path
    else
      flash[:danger] = 'Error'
      redirect_to dash_admin_teams_path
    end
  end
    
  def destroy
    @team.games.each do |g|
      if g.catchword_basket
        g.catchword_basket.destroy
      end
    end
    if @team.destroy
      flash[:success] = 'Team erfolgreich gelöscht!'
      redirect_to dash_admin_teams_path
    else
      flash[:danger] = 'Team NICHT gelöscht!'
      redirect_to dash_admin_teams_path
    end
  end
    
  private
    def set_admin
      @admin = current_admin
    end
    
    def set_team
      @team = Team.find(params[:team_id])
    end
    
    def team_params
      params.require(:team).permit(:name)
    end
end
