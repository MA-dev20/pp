class GamesController < ApplicationController
  before_action :authenticate_admin!, :set_admin

  def new
  end
    
  def create
    @game = Game.where(active: true, password: params[:game][:password]).first
    if @game && @game.admin_id == @admin.id
      session[:game_session_id] = @game.id
      @game.turns.update_all(status: 'ended')
      set_words_for_game(@game, params[:game][:own_rules], params[:game][:baskets], params[:game][:seconds])
      set_objections_for_game(@game, params[:game][:own_rules], params[:game][:objections])
      
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
          set_words_for_game(@game, params[:game][:own_rules], params[:game][:baskets], params[:game][:seconds])
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

    def set_words_for_game(game, own_rules, baskets, seconds)
      if own_rules == "true"
        game.wait_seconds = seconds
        game.own_words = true
        game.uses_peterwords = true if baskets.include?("")
        game.save!
        baskets-= [""]
        words = CatchwordsBasket.includes(:words).where('id IN (?)', baskets).map(&:words).flatten!
        game.build_catchword_basket.save! if game.catchword_basket.nil?
        game.catchword_basket.words.destroy_all
        game.catchword_basket.words << words if words.present?
      end
    end

    def set_objections_for_game(game, own_rules, objections_bas)
      if own_rules == "true"
        objections_basket_ids = objections_bas - [""]
        objections = ObjectionsBasket.includes(:objections).where('id IN (?)', objections_basket_ids).map(&:objections).flatten!
        game.build_objection_basket.save! if game.objection_basket.nil?
        game.objection_basket.objections.destroy_all
        objections = objections.first(10)
        if objections_bas.include?("")
          game.use_peterobjections = true
          objections+=ObjectionsBasket.peter_objections.first(10-objections.length) if objections.length < 10
        else
          game.use_peterobjections = false
        end
        game.objection_basket.objections << objections if objections.present?
        game.save!
      end
    end

    def set_admin
      @admin = current_admin
    end
end
