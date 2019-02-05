class DashAdminController < ApplicationController
  before_action :require_admin, :set_admin
  before_action :set_team, only: [:games, :team_stats, :team_users, :user_stats, :compare_user_stats]
  before_action :set_user, only: [:user_stats, :compare_user_stats]
  layout 'dash_admin'
    
  def index
  end
    
  def games
  end
    
  def teams
  end
    
  def team_stats
    @rating = @team.team_rating
    @gameratings = @team.game_ratings.last(7)
  end
    
  def users
    @users = @admin.users.all
  end
    
  def team_users
    @users = @team.users.all
  end
    
  def user_stats
    @users = @admin.users
    @turns = Turn.where(user_id: @user.id)
    @turns_rating = TurnRating.where(user_id: @user.id).last(7)
    @rating = UserRating.find_by(user_id: @user.id)
    if !@rating
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      redirect_to dash_admin_users_path
    end
  end
    
  def compare_user_stats
    @users = @admin.users
    @turns = Turn.where(user_id: @user.id)
    @turns_rating = TurnRating.where(user_id: @user.id).last(7)
    @rating = UserRating.find_by(user_id: @user.id)
      
    @user1 = User.find(params[:compare_user_id])
  end
    
  def account
  end
    
  private
    def set_admin
      @admin = current_admin
      @teams = @admin.teams
    end
    
    def set_team
      @team = Team.find(params[:team_id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end
end
