class BackofficeController < ApplicationController
  before_action :if_root
  before_action :require_root
  before_action :set_root, only: [:root, :edit_root, :update_root_avatar]
  before_action :set_admin, only: [:admin, :edit_admin, :update_admin_avatar, :update_admin_logo, :activate_admin, :destroy_admin, :teams, :team, :new_team, :users, :user, :new_user, :games, :game]
  before_action :set_user, only: [:user, :edit_user, :update_user_avatar, :destroy_user]
  before_action :set_team, only: [:team, :edit_team, :destroy_team]
  before_action :set_game, only: [:game, :edit_game, :destroy_game]
  before_action :set_vertrieb, only: [:sale_pictures, :update_vertrieb_avatar, :update_vertrieb_logo]
  before_action :set_blog, only: [:blog, :edit_blog, :update_blog_image, :destroy_blog]
  before_action :if_basket, only: [:words]
  before_action :set_basket, only: [:word, :objection]
  layout 'backoffice'
      
  #GET backoffice
  def index
    @admins = Admin.all
	if !is_root?
	  redirect_to backoffice_sales_path
	end
  end

  #GET backoffice_admins
  def admins
    @admins = Admin.all
  end
  #GET backoffice_admin @admin
  def admin
    @users = @admin.users.order(:fname)
	@users.order(:lname)
    @cw_baskets = @admin.catchword_baskets.where(objection: false)
    @ob_baskets = @admin.objection_baskets.all
  end  

  #GET backoffice_teams @admin
  def teams
	@teams = @admin.teams.order(:name)
  end
  #GET backoffice_team @admin @team
  def team
  end

  #GET backoffice_users @admin
  def users
	@users = @admin.users.order(:lname)
  end
  #GET backoffice_user @admin @user
  def user
  end
  
  #GET backoffice_games @admin
  def games
	@games = @admin.games
  end
  #GET backoffice_game @admin @game
  def game
  end
    
  #GET backoffice_words @admin
  #GET backoffice_words_noadmin
  def words
	if params[:admin_id]
	  @admin = Admin.find(params[:admin_id])
	  @words = CatchwordsBasket.where(admin_id: @admin.id, objection: false)
	else
	  @words = CatchwordsBasket.where(admin_id: nil, objection: false)
	end
  end
  #GET backoffice_word @admin
  #GET backoffice_word_noadmin
  def word
	if params[:admin_id]
	  @admin = Admin.find(params[:admin_id])
	else
	end
  end
	
  #GET backoffice_objections @admin
  #GET backoffice_objections_noadmin
  def objections
	if params[:admin_id]
	  @admin = Admin.find(params[:admin_id])
	  @objections = CatchwordsBasket.where(admin_id: @admin.id, objection: true)
	else
	  @objections = CatchwordsBasket.where(admin_id: nil, objection: true)
	end
  end
  #GET backoffice_objection @admin
  #GET backoffice_objection_noadmin
  def objection
	if params[:admin_id]
	  @admin = Admin.find(params[:admin_id])
	else
	end
  end
	
  #GET backoffice_roots
  def roots
	@roots = Root.all
  end
  #GET backoffice_root
  def root
	@this_root = Root.find(params[:root_id])
  end
	
  #GET backoffice_sales
  def sales
  end
	
  #GET backoffice_sale_pictures
  def sale_picture
  end
	
  #GET backoffice_blogs
  def blogs
	@blogs = Blog.all
  end
  #GET backoffice_blog
  def blog
  end
	
  ########
  # CRUD #
  ########
	
  # Admins
  def new_admin
    @admin = Admin.new(admin_params)
    @admin.skip_password_validation = true
    @admin.skip_confirmation!
    @admin.activated = true
    if !@admin.save
      flash[:danger] = "Konnte Admin nicht speichern!"
      redirect_to backoffice_admins_path
    end
    redirect_to backoffice_admin_path(@admin)
  end
  def activate_admin
	password = SecureRandom.urlsafe_base64(8)
    if @admin.update(activated: true, password: password)
	  AdminMailer.after_activate(@admin, password).deliver
	else
      flash[:danger] = 'Konnte Admin nicht aktivieren!'
    end
    redirect_to backoffice_admin_path(@admin)
  end
  def edit_admin
	@admin.skip_password_validation = true
	@admin.skip_reconfirmation!
	if !@admin.update(admin_params)
	  flash[:danger] = 'Konnte Admin nicht speichern!'
	end
	redirect_to backoffice_admin_path(@admin)
  end
  def update_admin_avatar
	@admin.skip_password_validation = true
	@admin.update(avatar: params[:file]) if params[:file].present? && @admin.present?
	render json: {file: @admin.avatar.url}
  end
  def update_admin_logo
	@admin.skip_password_validation = true
	@admin.update(logo: params[:file]) if params[:file].present? && @admin.present?
	render json: {file: @admin.logo.url}
  end
  def destroy_admin
	@admin.skip_password_validation = true
	if !@admin.destroy
	  flash[:danger] = "Konnte Admin nicht löschen!"
	end
	redirect_to backoffice_admins_path
  end
	
  # Teams
  def new_team
	@team = @admin.teams.new(name: params[:team][:name])
	if @team.save
	  redirect_to backoffice_team_path(@admin, @team)
	else
 	  flash[:danger] = 'Konnte Team nicht erstellen!'
	  redirect_to backoffice_teams_path(@admin)
	end
  end
  def edit_team
    @admin = @team.admin
	if !params[:team][:users].nil?
		@team.users.destroy_all
		params[:team][:users].each do |u|
		  if u != ''
			@team.users << User.find_by(id: u)
		  end
		end
	elsif params[:team][:name] && !@team.update(name: params[:team][:name])
	  flash[:danger] = 'Konnte Team nicht speichern!'
	end
	redirect_to backoffice_team_path(@admin, @team)
  end
  def destroy_team
	@admin = @team.admin
	if !@team.destroy
	  flash[:danger] = 'Konnte Team nicht löschen!'
    end
	redirect_to backoffice_teams_path(@admin)
  end

  # Users
  def new_user
	@user = User.new(user_params)
	@user.admin = @admin
	if @user.save
	  redirect_to backoffice_user_path(@admin, @user)
	else
	  flash[:danger] = 'Konnte User nicht erstellen!'
	  redirect_to backoffice_users_path(@admin)
	end
  end
  def edit_user
    @admin =  @user.admin
	if !params[:user][:teams].nil?
	  @user.teams.destroy_all
	  params[:user][:teams].each do |t|
	    if t != ""
          @user.teams << Team.find_by(id: t)
	    end
      end
	elsif !@user.update(user_params)
	  flash[:danger] = 'Konnte Nutzer nicht speichern!'
	end
	redirect_to backoffice_user_path(@admin, @user)
  end
  def update_user_avatar
	@user.update(avatar: params[:file]) if params[:file].present? && @user.present?
	render json: {file: @user.avatar.url}
  end
  def destroy_user
	@admin = @user.admin
	if !@user.destroy
	  flash[:danger] = 'Konnte User nicht löschen!'
	  redirect_to backoffice_user_path(@admin, @user)
	else
	  redirect_to backoffice_users_path(@admin)
	end
  end
	
  #Games
  def new_game
	@game = Game.create(game_params)
	@team = @game.team
	@admin = @game.admin
	@team.users.each do |u|
	  @word = CatchwordsBasket.find_by(name: 'PetersWords').words.all.sample(5).first
	  @game.turns.create(user_id: u.id, word_id: @word.id, play: true, played: false, counter: 0)
	end
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
	redirect_to backoffice_team_path(@admin, @team)
  end
  def edit_game
	@admin = @game.admin
	@date = params[:game][:created_at].to_date
	@game.update(created_at: @date)
	@game.turns.each do |t|
		t.update(created_at: @date)
		if TurnRating.find_by(turn_id: t.id)
		  TurnRating.find_by(turn_id: t.id).update(created_at: @date)
		end
	end
	redirect_to backoffice_game_path(@admin, @game)
  end
  def destroy_game
	@admin = @game.admin
	if !@game.destroy
	  flash[:danger] = 'Konnte Pitch nicht löschen!'
	end
	if params[:site]
	  if params[:site] == 'team'
		@team = @game.team
		redirect_to backoffice_team_path(@admin, @team)
	  end
	else
	  redirect_to backoffice_games_path(@admin)
	end
  end
	
  # Turns
  def destroy_turn
	@turn = Turn.find(params[:turn_id])
	@user = @turn.user
	@game = @turn.game
	@admin = @game.admin
	@turn.destroy
	if @game.turns.count == 0
	  @game.destroy
	end
	if params[:site]
	  if params[:site] == 'user'
		redirect_to backoffice_user_path(@admin, @user)
		return
	  end
	end
	if @game.turns.count == 0
	  redirect_to backoffice_games_path(@admin)
	else
	  redirect_to backoffice_game_path(@admin, @game)
	end
  end
	
  # Rating
  def update_rating
	@turn = Turn.find(params[:turn_id])
	@game = Game.find(@turn.game_id)
	@rating = TurnRating.find_by(turn_id: @turn.id)
	@user = User.find_by(id: @turn.user_id)
	@team = Team.find(@game.team_id)
	@body = params[:rating][:body].to_i
	@creative = params[:rating][:creative].to_i
	@rhetoric = params[:rating][:rhetoric].to_i
	@spontan = params[:rating][:spontan].to_i
	@ges = (@body + @creative + @rhetoric + @spontan) / 4
	@rating.update(ges: @ges, body: @body, creative: @creative,rhetoric: @rhetoric,spontan: @spontan)
	if @user
	  update_user_rating(@user)
	end
	update_game_rating(@game)
	update_team_rating(@team)
	if params[:rating][:site] == "backoffice_user"
		redirect_to backoffice_user_path(@user.admin, @user)
	elsif params[:rating][:site] == 'backoffice_game'
		redirect_to backoffice_game_path(@game.admin, @game)
	end
  end
	
  # Root
  def new_root
	@root = Root.new(root_params)
	password = SecureRandom.urlsafe_base64(8)
	@root.password = password
	if !@root.save
	  flash[:danger] = 'Konnte Mitarbeiter nicht speichern'
	else
	  RootMailer.after_create(@root, password).deliver
	end
	redirect_to backoffice_roots_path
  end
  def edit_root
	if !@root.update(root_params)
      flash[:danger] = 'Konnte Mitarbeiter nicht updaten'
	end
	redirect_to backoffice_root_path(@root)
  end
  def update_root_avatar
	@root.update(avatar: params[:file]) if params[:file].present? && @root.present?
	render json: {file: @root.avatar.url}
  end
  def destroy_root
	@troot = Root.find(params[:root_id])
	if !@troot.destroy
	  flash[:danger] = 'Konnte Root nicht löschen!'
	end
	redirect_to backoffice_roots_path
  end
	
  #Vertrieb
  def update_vertrieb_avatar
	@vertrieb.update(avatar: params[:file]) if params[:file].present? && @vertrieb.present?
	render json: {file: @vertrieb.avatar.url}
  end
  def update_vertrieb_logo
	@vertrieb.update(logo: params[:file]) if params[:file].present? && @vertrieb.present?
	render json: {file: @vertrieb.logo.url}
  end
	
  #Blog
  def new_blog
	@blog = Blog.new(blog_params)
	if @blog.save
	  redirect_to backoffice_blog_path(@blog)
	else
	  flash[:danger] = 'Konnte Blog nicht erstellen!'
	  redirect_to backoffice_blogs_path
	end
  end
  def edit_blog
	@blog.update(blog_params)
  end
  def update_blog_image
	@blog.update(image: params[:file]) if params[:file].present? && @blog.present?
	render json: {file: @blog.image.url}
  end
  def destroy_blog
	if !@blog.destroy
	  flash[:danger] = 'Konnte Blog nicht löschen!'
	end
	redirect_to backoffice_blogs_path
  end
	
#############
# Variables #
#############
  
  private

  def if_root
    if Root.count == 0
      Root.create(username: 'root', password: 'ratte')
    end
  end
  def set_root
    @root = Root.find(params[:root_id])
  end
  def set_admin
    @admin = Admin.find(params[:admin_id])
  end
  def set_team
	@team = Team.find(params[:team_id])
  end
  def set_user
    @user = User.find(params[:user_id])
  end
  def set_game
	@game = Game.find(params[:game_id])
  end
  def set_vertrieb
	@vertrieb = Vertrieb.find(params[:vertrieb_id])
  end
  def set_blog
	@blog = Blog.find(params[:blog_id])
  end
  def set_basket
    @basket = CatchwordsBasket.find(params[:basket_id])
  end
  def if_basket
    if CatchwordsBasket.where(name: 'PetersWords').count == 0
      CatchwordsBasket.create(name: 'PetersWords')
    end
    if ObjectionsBasket.where(name: 'PetersObjections').count == 0
      ObjectionsBasket.create(name: 'PetersObjections')
    end
  end
  def admin_params
    params.require(:admin).permit(:fname, :lname, :email, :password, :telephone, :street, :zipcode, :city, :company_name, :company_position, :employees)
  end
  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password)
  end
  def game_params
    params.require(:game).permit(:team_id, :admin_id)
  end
  def root_params
	params.require(:root).permit(:username, :email, :role, :password, :password_confirmation, :avatar)
  end
  def blog_params
	params.require(:blog).permit(:title, :text, :image)
  end
end
