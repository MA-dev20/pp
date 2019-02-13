class GamesController < ApplicationController
  before_action :authenticate_admin!, :set_admin

  def new
  end
    
  def create
    @game = Game.where(active: true, password: params[:game][:password]).first
    if @game && @game.admin_id == @admin.id
      game_login @game
      redirect_to gda_intro_path
    elsif @game && !@admin.admin_id == @admin.id
        flash[:danger] = 'Bitte wähle ein anderes Passwort'
        redirect_to dash_admin_games_path(params[:game][:team_id])
    else
      @game = Game.new(admin_id: @admin.id, team_id: params[:game][:team_id], active: true, state: 'intro', password: params[:game][:password])
      if @game.save
        game_login @game
        redirect_to gda_intro_path
      else
        flash[:danger] = 'Konnte Spiel nicht speichern'
        redirect_to dash_admin_games_path(params[:game][:team_id])
      end
    end
  end
    
  private
    def set_admin
      @admin = current_admin
    end
end
