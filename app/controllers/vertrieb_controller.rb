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
	@chartdata = []
	@chartdata << {date: '20.12.2019', ges: 98, spontan: 95, creative: 93, body: 93, rhetoric: 21, admin_ges: 34, admin_spontan: 23, admin_creative: 25, admin_body: 95, admin_rhetoric: 59, word: 'PlüschPferd'}
	@chartdata << {date: '10.12.2019', ges: 88, spontan: 85, creative: 83, body: 83, rhetoric: 81, admin_ges: 63, admin_spontan: 63, admin_creative: 65, admin_body: 65, admin_rhetoric: 69, word: 'PlüschPony'}
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
	  params.require(:vertrieb).permit(:fname, :name, :avatar, :logo, :team_name, :game_password, :password)
	end
end
