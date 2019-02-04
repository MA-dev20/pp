class TeamsController < ApplicationController
  before_action :require_admin, :set_admin
  before_action :set_team, only: [:destroy]

  def new
  end
    
  def new_game
  end
    
  def create
    @team = @admin.teams.new(team_params)
    if @team.save
      @rating = TeamRating.new(team_id: @team.id, ges: 0, body: 0, creative: 0, rhetoric: 0, spontan: 0)
      @rating.save
      redirect_to dash_admin_teams_path
    else
      flash[:danger] = 'Team konnte nicht erstellt werden!'
      redirect_to dash_admin_teams_path
    end
  end
    
  def create_game
    @team = @admin.teams.new(team_params)
    if @team.save
      @team_rating = TeamRating.new(team_id: @team.id, ges: 0, body: 0, creative: 0, rhetoric: 0, spontan: 0)
      @team_rating.save
      redirect_to dash_admin_games_path(@team)
    else
      flash[:danger] = 'Team konnte nicht erstellt werden!'
      redirect_to dash_admin_path
    end
  end
    
  def destroy
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
