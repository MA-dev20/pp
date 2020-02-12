class VertriebController < ApplicationController
  before_action :set_vertrieb, except: [:new, :create, :login, :ended]
  layout 'main'
	
  def new
  end
	
  def create
	@vertrieb = Vertrieb.new(vertrieb_params)
	@vertrieb.state = "start"
	if !@vertrieb.save
	  flash[:danger] = 'Konnte Vertrieb nicht starten!'
	  render "new"
	else
	  vertrieb_login @vertrieb
	  redirect_to backoffice_sale_pictures_path(@vertrieb)
	end
  end
	
  def login
	@vertrieb = Vertrieb.where(password: params[:vertrieb][:password], state: "start").first
	if @vertrieb
	  vertrieb_login @vertrieb
	  redirect_to start_vertrieb_path()
	else
	  flash[:wrong_pw] = 'falsches Passwort!'
	  render "new"
	end
  end
	
  def start
	render layout: 'vertrieb'
  end
	
	
  def proceed
	render layout: 'vertrieb'
	if @vertrieb.state == 'start'
      @vertrieb.update(state: 'proceed')
	end
  end
	
  def dash_lets_pitch
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'proceed'
	  @vertrieb.update(state: 'dash_lets_pitch')
	end
  end
	
  def dash_lets_pitch2
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'dash_lets_pitch'
	  @vertrieb.update(state: 'dash_lets_pitch2')
	end
  end

  def game_wait
	@handy = true
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'dash_lets_pitch2'
	  @vertrieb.update(state: 'game_wait')
	end
  end
	
  def game_choose
	@handy = true
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_wait'
	  @vertrieb.update(state: 'game_choose')
	end
  end
	
  def game_turn
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_choose'
	  @vertrieb.update(state: 'game_turn')
	end
  end
	
  def game_play
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_turn'
	  @vertrieb.update(state: 'game_play')
	end
  end
	
  def game_rate
	@handy = true
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_play'
	  @vertrieb.update(state: 'game_rate')
	end
  end
	
  def game_rated
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_rate'
	  @vertrieb.update(state: 'game_rated')
	end
  end
	
  def game_bestlist
	render layout: 'vertrieb_game'
	if @vertrieb.state == 'game_rated'
	  @vertrieb.update(state: 'game_bestlist')
	end
  end
 
  def dash_users
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'game_bestlist'
	  @vertrieb.update(state: 'dash_users')
	end
  end
	
  def dash_user_stats
	date = @vertrieb.created_at.strftime('%d.%m.%Y')
	@chartdata = []
	@chartdata << {date: '03.01.2020', ges: 43, spontan: 50, creative: 11, body: 75, rhetoric: 38, admin_ges: 45, admin_spontan: 21, admin_creative: 64, admin_body: 28, admin_rhetoric: 68, word: 'SchuppenSchal'}
	@chartdata << {date: '10.01.2020', ges: 52, spontan: 74, creative: 36, body: 31, rhetoric: 67, admin_ges: 41, admin_spontan: 75, admin_creative: 15, admin_body: 17, admin_rhetoric: 60, word: 'TennisPfanne'}
	@chartdata << {date: '17.01.2020', ges: 51, spontan: 40, creative: 63, body: 40, rhetoric: 63, admin_ges: 62, admin_spontan: 28, admin_creative: 99, admin_body: 68, admin_rhetoric: 54, word: 'WildWarner'}
	@chartdata << {date: '24.01.2020', ges: 66, spontan: 83, creative: 85, body: 63, rhetoric: 33, admin_ges: 68, admin_spontan: 11, admin_creative: 88, admin_body: 91, admin_rhetoric: 83, word: 'WanderSchrank'}
	@chartdata << {date: '31.01.2020', ges: 77, spontan: 93, creative: 86, body: 64, rhetoric: 68, admin_ges: 78, admin_spontan: 78, admin_creative: 67, admin_body: 78, admin_rhetoric: 87, word: 'DreckSeife'}
	@chartdata << {date: date, ges: 98, spontan: 95, creative: 93, body: 93, rhetoric: 21, admin_ges: 88, admin_spontan: 99, admin_creative: 94, admin_body: 65, admin_rhetoric: 94, word: 'PlüschPferd'}
	
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'dash_users'
	  @vertrieb.update(state: 'dash_user_stats')
	end
  end
	
  def dash_videoanalyse
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'dash_user_stats'
	  @vertrieb.update(state: 'dash_videoanalyse')
	end
  end
	
  def dash_customize
	render layout: 'vertrieb_dash'
	if @vertrieb.state == 'dash_videoanalyse'
	  @vertrieb.update(state: 'dash_customize')
	end
  end
	
  def ended
	render layout: 'vertrieb'
	if current_vertrieb
	  @vertrieb = current_vertrieb
	  if @vertrieb.state == 'dash_customize'
	    @vertrieb.update(state: 'ended')
	  end
	  vertrieb_logout
	  @vertrieb.destroy
	end
  end
	
  private
	def set_vertrieb
	  @vertrieb = current_vertrieb
	  if root_logged_in?
	    @root = current_root
	  end
	end
	
    def vertrieb_params
	  params.require(:vertrieb).permit(:root_id, :fname, :name, :avatar, :logo, :team_name, :game_password, :password)
	end
end
