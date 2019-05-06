class GamesController < ApplicationController
  before_action :authenticate_admin!, :set_admin

  def new
  end
    
  def create
    @game = Game.where(active: true, password: params[:game][:password]).first
    if @game && @game.admin_id == @admin.id
      session[:game_session_id] = @game.id
      set_words_for_game(@game, params[:game][:own_rules], params[:game][:words], params[:game][:seconds])
      sign_in(@game)
      # send_invitation_emails_to_team_members(Team.find(params[:game][:team_id]), @game) if params[:game][:team_id].present?
      redirect_to gda_intro_path
    elsif @game && @game.admin_id != @admin.id
        flash[:pop_up] = "Ups, diese URL ist schon vergeben!;- Sei kreativ und wähle eine ander aus. -"
        redirect_to dash_admin_games_path(params[:game][:team_id])
    else
      if params[:game][:team_id].present?
        @game = Game.new(admin_id: @admin.id, team_id: params[:game][:team_id], active: true, state: 'intro', password: params[:game][:password])
        if @game.save
          set_words_for_game(@game, params[:game][:own_rules], params[:game][:words], params[:game][:seconds])
          sign_in(@game)
          # send_invitation_emails_to_team_members(Team.find(params[:game][:team_id]), @game) if params[:game][:team_id].present?
          session[:game_session_id] = @game.id
          redirect_to gda_intro_path
        else
          flash[:danger] = 'Konnte Spiel nicht speichern'
          redirect_to dash_admin_games_path(params[:game][:team_id])
        end
      else
        puts "location back"
        redirect_back fallback_location: root_path
      end
    end
  end
   
  def show
    @messages = Message.all
  end

  private
    def set_words_for_game(game, own_rules, words, seconds)
      if own_rules == "true"
        game.update(wait_seconds: seconds, own_words: true)
        words = Word.where('id IN (?)', words)
        game.has_or_create_basket_for_words.words.destroy_all
        game.has_or_create_basket_for_words.words << words
      end
    end
    def set_admin
      @admin = current_admin
    end
end
