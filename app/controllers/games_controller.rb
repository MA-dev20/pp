class GamesController < ApplicationController
  before_action :authenticate_admin!, :set_admin

  def new
  end
    
  def create
    @game = Game.where(active: true, password: params[:game][:password]).first
    if params[:game][:team_id].nil?
      flash[:select_team] = 'Wähle ein Team!'
    end
    if params[:game][:password].empty?
      flash[:missing_password] = 'Gib eine Url an!'
    end
    if params[:game][:baskets]&.first&.empty?
      flash[:select_catchword] = 'Wähle zumindest eine Liste'
    end
    if params[:game][:objections]&.first&.empty?
      flash[:select_objection] = 'Wähle zumindest eine Liste'
    end
    if params[:game][:team_id].nil?
      redirect_to dash_admin_path()
      return
    elsif params[:game][:password].empty? || params[:game][:baskets]&.first&.empty? || params[:game][:objections]&.first&.empty?
      redirect_to dash_admin_games_path(params[:game][:team_id])
      return
    end
    if @game && @game.admin_id == @admin.id
      session[:game_session_id] = @game.id
      @game.turns.update_all(status: 'ended')
      set_words_for_game(@game, params[:game][:baskets], params[:game][:seconds])
      set_objections_for_game(@game, params[:game][:objections])
	    set_video_for_game(@game, params[:game][:video_name], params[:game][:video], params[:game][:video_turn], params[:game][:youtube_url])
      sign_in(@game)
      # send_invitation_emails_to_team_members(Team.find(params[:game][:team_id]), @game) if params[:game][:team_id].present?
      redirect_to gda_wait_path
    elsif @game && @game.admin_id != @admin.id
        flash[:pop_up] = "Ups, diese URL ist schon vergeben!;-"
		flash[:pop_up2] = "Sei kreativ und wähle eine andere aus."
        redirect_to dash_admin_games_path(params[:game][:team_id])
    else
      @game = Game.new(admin_id: @admin.id, team_id: params[:game][:team_id], active: true, state: 'intro', password: params[:game][:password])
      if @game.save
        set_words_for_game(@game, params[:game][:baskets], params[:game][:seconds])
        set_objections_for_game(@game, params[:game][:objections])
		set_video_for_game(@game, params[:game][:video_name], params[:game][:video], params[:game][:video_turn], params[:game][:youtube_url])
        sign_in(@game)
        # send_invitation_emails_to_team_members(Team.find(params[:game][:team_id]), @game) if params[:game][:team_id].present?
        session[:game_session_id] = @game.id
        redirect_to gda_wait_path
      else
        flash[:danger] = 'Konnte Spiel nicht speichern'
        redirect_to dash_admin_games_path(params[:game][:team_id])
      end
    end
  end
   
  def show
    @messages = Message.all
  end

  private

    def set_words_for_game(game, baskets, seconds)
      game.wait_seconds = seconds
      game.uses_peterwords = true if baskets.include?("pp")
      baskets-= ["pp"]
      game.own_words = true if !baskets.empty?
      game.save!
      words = CatchwordsBasket.includes(:words).where('id IN (?)', baskets).map(&:words).flatten!
      game.build_catchword_basket.save! if game.catchword_basket.nil?
      game.catchword_basket.words.destroy_all
      game.catchword_basket.words << words if words.present?
    end

    def set_objections_for_game(game, objections_bas)
      objections_basket_ids = objections_bas - ["pp"]
      if !objections_basket_ids.empty?
      objections = ObjectionsBasket.includes(:objections).where('id IN (?)', objections_basket_ids).map(&:objections).flatten!
      game.build_objection_basket.save! if game.objection_basket.nil?
      game.objection_basket.objections.destroy_all
      objections = objections.first(10)
      if objections_bas.include?("pp")
        game.use_peterobjections = true
        objections+=ObjectionsBasket.peter_objections.first(10-objections.length) if objections.length < 10
      else
        game.use_peterobjections = false
      end
      game.objection_basket.objections << objections if objections.present?
      game.save!
      end
    end
	
	def set_video_for_game(game, video_name, video, video_turn, youtube)
	  if !video.nil?
	  	@video = Video.find_by(id: video.first)
	  end
	  if !video_turn.nil?
	  	@pitch = Turn.find_by(id: video_turn.first)
	  end
	  if youtube != ''
		game.youtube_url = youtube
	  elsif @video && @video.name == video_name
		game.youtube_url = nil
		game.video = @video.id
		game.video_is_pitch = false
	  elsif @pitch
		game.youtube_url = nil
		game.video = @pitch.id
		game.video_is_pitch = true
	  else
		game.video = nil
		game.youtube_url = nil
	  end
	  game.save!
	end

    def set_admin
      @admin = current_admin
    end
end
