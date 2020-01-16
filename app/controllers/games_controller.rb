class GamesController < ApplicationController
  before_action :authenticate_admin!, :set_admin, except: [:destroy, :create_bo]
  before_action :require_root, :set_root, only: [:destroy, :create_bo]

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
    if params[:game][:team_id].nil?
      redirect_to dash_admin_path()
      return
    elsif params[:game][:password].empty?
      redirect_to dash_admin_games_path(params[:game][:team_id])
      return
    end
    if @game && @game.admin_id == @admin.id
      @game.turns.update_all(status: 'ended')
      redirect_to dash_admin_create_game_2_path(@game)
    elsif @game && @game.admin_id != @admin.id
        flash[:pop_up] = "Ups, diese URL ist schon vergeben!;-"
		flash[:pop_up2] = "Sei kreativ und wähle eine andere aus."
        redirect_to dash_admin_games_path(params[:game][:team_id])
    else
      @game = Game.new(admin_id: @admin.id, team_id: params[:game][:team_id], active: true, state: 'intro', password: params[:game][:password])
      if @game.save
        redirect_to dash_admin_create_game_2_path(@game)
      else
        flash[:danger] = 'Konnte Spiel nicht speichern'
        redirect_to dash_admin_games_path(params[:game][:team_id])
      end
    end
  end
	
  def create_2
	@game = Game.find(params[:game_id])
	if !params[:game][:baskets].nil?
	  set_words_for_game(@game, params[:game][:baskets], params[:game][:seconds])
	elsif params[:game][:baskets].nil?
	  set_words_for_game(@game, ["pp"], params[:game][:seconds])
	end
	set_objections_for_game(@game, params[:game][:objections])
	set_video_for_game(@game, params[:game][:video_name], params[:game][:video], params[:game][:video_turn], params[:game][:youtube_url])
	sign_in(@game)
	session[:game_session_id] = @game.id
    redirect_to gda_wait_path
  end
	
  def update
	@game1 = Game.where(active: true, password: params[:game][:password]).first
	@game = Game.find(params[:game_id])
	if params[:game][:team_id].nil?
      flash[:select_team] = 'Wähle ein Team!'
    end
    if params[:game][:password].empty?
      flash[:missing_password] = 'Gib eine Url an!'
    end
    if params[:game][:team_id].nil?
      redirect_to dash_admin_path()
      return
    elsif params[:game][:password].empty?
      redirect_to dash_admin_games_path(params[:game][:team_id])
      return
    end
	if @game1 && @game1.admin_id != @admin.id
        flash[:pop_up] = "Ups, diese URL ist schon vergeben!;-"
		flash[:pop_up2] = "Sei kreativ und wähle eine andere aus."
        redirect_to dash_admin_games_path(params[:game][:team_id])
    else
      if @game.update(team_id: params[:game][:team_id], active: true, state: 'intro', password: params[:game][:password])
        redirect_to dash_admin_create_game_2_path(@game)
      else
        flash[:danger] = 'Konnte Spiel nicht speichern'
        redirect_to dash_admin_games_path(params[:game][:team_id])
      end
    end
  end
	
  def create_bo
	@game = Game.create(game_params)
	params[:game][:users].each do |u|
      @word = CatchwordsBasket.find_by(name: 'PetersWords').words.all.sample(5).first
	  @game.turns.create(user_id: u, word_id: @word.id, play: true, played: false, counter: 0)
	end
	@team = Team.find(params[:game][:team_id])
	@game.turns.each do |t|
	  @user = User.find(t.user_id)
	  @body = rand(100)
	  @creative = rand(100)
	  @rhetoric = rand(100)
	  @spontan = rand(100)
	  @ges = (@body + @creative + @rhetoric + @spontan) / 4
	  t.ratings.create(turn_id: t.id, admin_id: @game.admin_id, ges: @ges, body: @body, creative: @creative, rhetoric: @rhetoric, spontan: @spontan)
	  @body = rand(100)
	  @creative = rand(100)
	  @rhetoric = rand(100)
	  @spontan = rand(100)
	  @ges = (@body + @creative + @rhetoric + @spontan) / 4
	  TurnRating.create(turn_id: t.id, admin_id: @game.admin_id, user_id: t.user_id, game_id: t.game_id, ges: @ges, body: @body, creative: @creative, rhetoric: @rhetoric, spontan: @spontan)
	  update_user_rating(@user)
	  t.update(played: true)
	end
	update_game_rating(@game)
	update_team_rating(@team)
	place = 1
	@game.turn_ratings.rating_order.each do |tr|
	  Turn.find(tr.turn_id).update(place: place)
	  place += 1
	end
	redirect_to backoffice_edit_team_path(@team)
  end
   
  def show
    @messages = Message.all
  end
	
  def destroy
	@game = Game.find(params[:game_id])
	@admin = @game.admin
	if @game.destroy
	  redirect_to backoffice_edit_admin_path(@admin.id)
	else
	  redirect_to backoffice_edit_game_path(@game.id)
	end
  end

  private

    def set_words_for_game(game, baskets, seconds)
	  game.wait_seconds = seconds
      game.uses_peterwords = true if baskets&.include?("pp")
      baskets-= ["pp"] if baskets.present?
      game.own_words = true if !baskets&.empty?
      game.save!
      words = CatchwordsBasket.includes(:words).where('id IN (?)', baskets).map(&:words).flatten!
      game.build_catchword_basket.save! if game.catchword_basket.nil?
      game.catchword_basket.words.destroy_all
      game.catchword_basket.words << words if words.present?
    end

    def set_objections_for_game(game, objections_bas)
      if objections_bas.present?
        objections_basket_ids = objections_bas - ["pp"]
      end
      if !objections_basket_ids&.empty?
      objections = ObjectionsBasket.includes(:objections).where('id IN (?)', objections_basket_ids).map(&:objections).flatten!
      game.build_objection_basket.save! if game.objection_basket.nil?
      game.objection_basket.objections.destroy_all
      objections = objections&.first(10)
      if objections_bas&.include?("pp")
        game.use_peterobjections = true
        if objections.present?
          objections+=ObjectionsBasket.peter_objections.first(10-objections.length) if objections.length < 10
        end
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
	
	def set_root
	  @root = current_root
	end
	
	def game_params
	  params.require(:game).permit(:team_id, :admin_id)
	end
end
