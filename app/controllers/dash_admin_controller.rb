class DashAdminController < ApplicationController
  before_action :authenticate_admin!, :set_admin , :is_activated, unless: :skip_action?
  before_action :set_team, only: [:games, :team_stats, :team_users, :team_stats_share]
  before_action :set_user, only: [:user_stats, :user_stats_compare]
  # skip_before_action :check_expiration_date, only: [:billing, :user_list]
  
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
  layout :resolve_layout
  
  #Let's Play
  def index
    @users = @admin.users
    if params[:team_id]
      @team = Team.find(params[:team_id])
    end
  end
    
  #User
  def teams
    if params[:team_id]
      @team = Team.find(params[:team_id])
      @users = @team.users.order("avatar ASC").limit(10)
    elsif params[:user_id]
      @user = User.find(params[:user_id])
      @users = @admin.users.order("avatar ASC").limit(10)
    else
      @users = @admin.users.order("avatar ASC").limit(10)
    end
  end
    
  #Stats
    
  def user_stats
    if @user.turns.count == 0 || !@user.user_rating.present?
      redirect_to dash_admin_teams_path
      return
    end
    @users = @admin.users.all
    @turns = @user.turns.all
    @user_rating = @user.user_rating
    @turn_ratings = @user.turn_ratings.order('created_at ASC')
    @date = @turn_ratings.first&.created_at&.beginning_of_day
    @days = 1;
    @turn_ratings.each do |tr|
        bod = tr.created_at.beginning_of_day
        if @date != bod
            @date = bod
            @days = @days + 1
        end
    end
    @user_ratings = []
    @users.each do |u|
        if u.user_rating
          @user_ratings << {user_id: u.id, fname: u.fname, rating: u.user_rating.ges.present? ? u.user_rating.ges : 0 }
        end
    end

    @team = @user.teams.first
    @team_userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings, :turns).distinct
    @team_users = []
    @team_userss.each do |u|
      ges =  u.user_rating&.ges.present? ? u.user_rating.ges.to_f : 0.0
      spon = u.user_rating&.spontan.present? ? u.user_rating.spontan.to_f : 0.0
      creative =  u.user_rating&.creative.present? ? u.user_rating.creative.to_f : 0.0
      rhetoric = u.user_rating&.rhetoric.present? ? u.user_rating.rhetoric.to_f : 0.0
      body = u.user_rating&.body.present? ? u.user_rating.body.to_f : 0.0
      average =  (ges + spon + creative + rhetoric + body) / 5
      @team_users << {user_id: u.id, fname: u.fname, lname: u.lname, ges: ges, spon: spon, rhetoric: rhetoric, creative: creative, body: body, average: average, gold: u.gold_count, silver: u.silver_count, bronze: u.bronze_count}
    end
    @team_users = @team_users.sort_by {|u| -u[:average]}

    @user_ratings.sort_by{|e| -e[:rating] if e[:rating].present? }
    @chartdata = @turn_ratings.map{|t| {turn_id: t.turn_id, date: t.created_at.strftime("%d.%m.%Y"), ges: t.ges, spontan: t.spontan, creative: t.creative, body: t.body, rhetoric: t.rhetoric}}
  end
    
  def user_stats_compare
    @user2 = User.find(params[:user2_id])
    if @user.turns.count == 0 || @user2.turns.count == 0
      redirect_to dash_admin_teams_path
      return
    end
    @users = @admin.users.all
    @turns = @user.turns.all
    @user_rating = @user.user_rating
    @turn_ratings = @user.turn_ratings.order('created_at ASC')
    @date = @turn_ratings.first.created_at.beginning_of_day
    @days = 1
    @turn_ratings.each do |tr|
      bod = tr.created_at.beginning_of_day
      if @date != bod
        @date = bod
        @days = @days + 1
      end
    end
    @user_ratings = []
    @users.each do |u|
      if u.user_rating
        @user_ratings << {user_id: u.id, fname: u.fname, rating: u.user_rating.ges.present? ? u.user_rating.ges : 0}
      end
    end


    @team = @user.teams.first
    @team_userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings, :turns).distinct
    @team_users = []
    @team_userss.each do |u|
      ges =  u.user_rating&.ges.present? ? u.user_rating.ges.to_f : 0.0
      spon = u.user_rating&.spontan.present? ? u.user_rating.spontan.to_f : 0.0
      creative =  u.user_rating&.creative.present? ? u.user_rating.creative.to_f : 0.0
      rhetoric = u.user_rating&.rhetoric.present? ? u.user_rating.rhetoric.to_f : 0.0
      body = u.user_rating&.body.present? ? u.user_rating.body.to_f : 0.0
      average =  (ges + spon + creative + rhetoric + body) / 5
      @team_users << {user_id: u.id, fname: u.fname, lname: u.lname, ges: ges, spon: spon, rhetoric: rhetoric, creative: creative, body: body, average: average, gold: u.gold_count, silver: u.silver_count, bronze: u.bronze_count}
    end
    @team_users = @team_users.sort_by {|u| -u[:average]}


    @user_ratings.sort_by{|e| -e[:rating]}
    @chartdata = []
    @turn_ratings.each do |t|
      @turnrating2 = TurnRating.where(game_id: t.game_id, user_id: @user2.id).first
      if @turnrating2
        @chartdata << {game_id: t.game_id, turn_id: t.turn_id, date: t.created_at.strftime("%d.%m.%Y"), ges: t.ges, spontan: t.spontan, creative: t.creative, body: t.body, rhetoric: t.rhetoric, ges2: @turnrating2.ges,  spontan2: @turnrating2.spontan, creative2: @turnrating2.creative, body2: @turnrating2.body, rhetoric2: @turnrating2.rhetoric}
      else
        @chartdata << {game_id: t.game_id, turn_id: t.turn_id, date: t.created_at.strftime("%d.%m.%Y"), ges: t.ges, spontan: t.spontan, creative: t.creative, body: t.body, rhetoric: t.rhetoric}
      end
    end
  end
    
  def team_stats
    # debugger
    @team_rating = TeamRating.find_by(team_id: @team.id)
    if @team_rating.nil?
      redirect_to dash_admin_teams_path
      return
    end
    @games = Game.where(team_id: @team.id)
    @game_ratings = GameRating.where(team_id: @team.id)
    @date = @games.first.created_at.beginning_of_day
    @days = 1
    @games.each do |g|
        bod = g.created_at.beginning_of_day
        if @date != bod
            @date = bod
            @days = @days + 1
        end
    end
    @team_userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings, :turns).distinct
    @reviewed_videos = @team_userss.map do |user| 
      user.turns.where.not(recorded_pitch: nil)
    end
    @reviewed_videos.flatten!
    @reviewed_videos.sort_by! {|t| t.created_at}
    @reviewed_videos.reverse!
    @teams = @admin.teams.all
    @user_ratings = []
    @team_users = []
    @team.users.each do |u|
        if u.user_rating
            @user_ratings << {user_id: u.id, fname: u.fname, rating: u.user_rating&.ges.present? ? u.user_rating.ges : 0}
        end
        # @selected_user = @team_userss.select { |user| user.id == u.id }.first
        # @team_users << {user_id: u.id, fname: u.fname, lname: u.lname, ges: u.user_rating&.ges.present? ? u.user_rating.ges.to_f : 0.0, spon: u.user_rating&.spontan.present? ? u.user_rating.spontan.to_f : 0.0, rhetoric: u.user_rating&.rhetoric.present? ? u.user_rating.rhetoric.to_f : 0.0, creative: u.user_rating&.creative.present? ? u.user_rating.creative.to_f : 0.0, body: u.user_rating&.body.present? ? u.user_rating.body.to_f : 0.0, gold: @selected_user.gold_count, silver: @selected_user.silver_count, bronze: @selected_user.bronze_count}
    end
    @team_userss.each do |u|
      ges =  u.user_rating&.ges.present? ? u.user_rating.ges.to_f : 0.0
      spon = u.user_rating&.spontan.present? ? u.user_rating.spontan.to_f : 0.0
      creative =  u.user_rating&.creative.present? ? u.user_rating.creative.to_f : 0.0
      rhetoric = u.user_rating&.rhetoric.present? ? u.user_rating.rhetoric.to_f : 0.0
      body = u.user_rating&.body.present? ? u.user_rating.body.to_f : 0.0
      average =  (ges + spon + creative + rhetoric + body) / 5
      @team_users << {user_id: u.id, fname: u.fname, lname: u.lname, ges: ges, spon: spon, rhetoric: rhetoric, creative: creative, body: body, average: average, gold: u.gold_count, silver: u.silver_count, bronze: u.bronze_count}
    end
    @team_users = @team_users.sort_by {|u| -u[:average]}
    @user_ratings.sort_by{|e| -e[:rating]}
    @chartdata = @game_ratings.map{|g| {game_id: g.game_id, date: g.created_at.strftime("%d.%m.%Y"), ges: g.ges, spontan: g.spontan, creative: g.creative, body: g.body, rhetoric: g.rhetoric}}
  end

    
  #Customize
  def customize
    if params[:cbasket_id]
        @catchword = @admin.catchword_baskets.find(params[:cbasket_id])
    elsif params[:obasket_id]
        @objection = @admin.objection_baskets.find(params[:obasket_id])
    end
    cwords = @admin.catchword_baskets.where(objection: false, image: nil)
    cwords.each do |cword|
      rand_value = true
      (1..8).each do |i|
        if !@admin.catchword_baskets.where(objection: false, image: i).present?
          rand_value = false
          cword.update(image: i)
          break
        end
      end
      if rand_value
        rand_img = Random.new.rand(1..8)
        cword.update(image: rand_img)
      end
    end
    owords = @admin.objection_baskets.where(image: nil)
    owords.each do |oword|
      rand_value = true
      (1..8).each do |i|
        if !@admin.objection_baskets.where(image: i).present?
          rand_value = false
          oword.update(image: i)
          break
        end
      end
      if rand_value
        rand_img = Random.new.rand(1..8)
        oword.update(image: rand_img)
      end
    end
    @catchwords = @admin.catchword_baskets.where(objection: false)
    @objections = @admin.objection_baskets
  end
    
  #Video Tool
  def video_tool
    @sort_by = params[:sort_by]
    @turn = @admin.turns.where(recorded_pitch: nil).first
    @users = @admin.users
    @turns = @admin.turns.where.not(recorded_pitch: nil).order('created_at ASC')
    @result = []
    @turns.each do |t|
      @result << {turn_id: t.id, favorite: t.favorite, pitch_url: t.recorded_pitch.thumb.url, word: Word.find(t.word_id).name, user_avatar: t.findUser.avatar.quad.url, user_fname: t.findUser.fname, user_lname: t.findUser.lname, date: t.created_at, rating: TurnRating.find_by(turn_id: t.id)&.ges}
    end
    if @sort_by == 'fnameASC'
      @result = @result.sort{|a,b| a[:user_fname].downcase <=> b[:user_fname].downcase}
    elsif @sort_by == 'fnameDSC'
      @result = @result.sort{|b,a| a[:user_fname].downcase <=> b[:user_fname].downcase}
    elsif @sort_by == 'lnameASC'
      @result = @result.sort{|a,b| a[:user_lname].downcase <=> b[:user_lname].downcase}
    elsif @sort_by == 'lnameDSC'
      @result = @result.sort{|b,a| a[:user_lname].downcase <=> b[:user_lname].downcase}
    elsif @sort_by == 'ratingASC'
      @result = @result.sort{|a,b| a[:rating].to_i <=> b[:rating].to_i}
    elsif @sort_by == 'ratingDSC'
      @result = @result.sort{|b,a| a[:rating] <=> b[:rating]}
    elsif @sort_by == 'dateDSC'
      @result = @result.sort{|b,a| a[:date] <=> b[:date]}
    else
      @result = @result.sort{|a,b| a[:date] <=> b[:date]}
    end
  end
    
  def video_details
    @turn = Turn.find(params[:turn_id])
    @comments = @turn.comments.order('time_of_video ASC')
    @word = Word.find(@turn.word_id)
    @user = @turn.findUser
    @rating = @turn.turn_rating
    @my_rating = @turn.ratings.find_by(admin_id: @admin.id)
  end

  def add_favorite
    Turn.find(params[:id]).update(favorite: true)
  end

  def remove_favorite
    Turn.find(params[:id]).update(favorite: false)
  end
    
  #Account
  def account
  end
    
  def add_video_to_turn
  end
    
  def save_video_to_turn
    @turn = Turn.find(params[:turn_id])
    @turn.update(recorded_pitch: params[:file])
  end
    
  def generate_img_from_html
    kit = html_to_jpg(params[:html], params[:team_id])
    respond_to do |format| 
      url = to_file(kit, params[:team_id])
      format.js do
        render json: {url: "#{url}"}
      end
      # format.png do
      #   send_data(kit.to_png, :type => "image/png", :disposition => 'inline')
      # end
    end
  end

  def turn_show
    @turns_rating = TurnRating.find(params[:turn_id])
    @turn = @turns_rating.turn
    @user = @turn.user
    @turn.review
    @ratings = @turn.ratings
    @creative = @ratings.average(:creative).to_f
    @body = @ratings.average(:body).to_f
    @rhetoric = @ratings.average(:rhetoric).to_f
    @spontan = @ratings.average(:spontan).to_f
    @average = (@spontan + @rhetoric + @body + @creative)/4
    @admin_ratings = Rating.where(turn_id:  @turn.id,admin_id: @admin.id).first
    render :show_turn
  end

  def delete_video
    @turn = Turn.find(params[:turn_id])
    @turn.recorded_pitch.remove!
    @turn.recorded_pitch = nil
    @turn.save!
  end

  def get_words
    render json: current_admin.has_or_create_basket_for_words.map{|t| {id: t.id, name: t.name.nil? ? " " : t.name}}.to_json
  end

  def get_objections
    objections = []
    objections = current_admin.objection_baskets.map{|t| {id: t.id, name: t.name.nil? ? " " : t.name}}.to_json if current_admin.objection_baskets.present?
    render json:  objections
  end

  def add_word
    @already = false
    @basket = @admin.catchword_baskets.find(params[:basket_id])
    if @basket.words.find_by_name(params[:name]).present?
        @already = true        
    else
      @word = Word.new(name: params[:name])
      @word.save!
      @basket.words << @word
    end
    @count = @basket.words.count
    @id = params[:basket_id]
    respond_to do |format|
      format.js do
        render :add_word
      end
    end
  end

  def add_objection
    @already = false
    @basket = @admin.objection_baskets.find(params[:basket_id])
    if @basket.objections.find_by_name(params[:name]).present?
        @already = true        
    else
      objection = Objection.new(name: params[:name])
      objection.save!
      @basket.objections << objection
      @word = objection
    end
    @count = @basket.objections.count
    @id = params[:basket_id]
    respond_to do |format|
      format.js do
        render :add_word
      end
    end
  end

  def update_objection
    @word = Objection.find(params[:id])
    @word.update(sound: params[:file]) if params[:file].present? &&  @word.present?
    render json: {sound:  @word.sound.url}
  end

  def update_word 
    @word = Word.find(params[:id])
    @word.update(sound: params[:file]) if params[:file].present? &&  @word.present?
    render json: {sound:  @word.sound.url}
  end

  def release_comments
    @turn = Turn.find(params[:turn_id])
    @turn.comments.update_all(:release_it => true)
    @receiver = @turn.user
    @receiver = @turn.admin if !@receiver.present?
    ReceivedCommentsJob.perform_later(@receiver,@turn)
    render json: {res: "ok"}
  end

  def remove_word
    @admin.catchword_baskets.find(params[:basket_id]).words.delete(Word.find(params[:word_id]))
    render json: {count: @admin.catchword_baskets.find(params[:basket_id]).words.count }
  end


  def remove_objection
    @objection = @admin.objection_baskets.find(params[:basket_id]).objections.find(params[:word_id])
    @objection.destroy
    render json: {count: @admin.objection_baskets.find(params[:basket_id]).objections.count }
  end

  def catchwords
    @baskets = @admin.catchword_baskets.where.not(objection: true)
  end

  def objections
    @baskets = @admin.objection_baskets 
  end

  def team_stats_share
    userss = @team.users.includes(:turn_ratings).distinct
    raw_result = users_ratings userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
  end
    

  def user_list
    render json: UsersDatatable.new(view_context) 
  end

  def statistics
    @users = @admin.users
    @team = @teams.first
    @turns = @admin.turns.where(admin_turn: true).order('created_at DESC')
    @reviewed_videos = @turns.where.not(recorded_pitch: nil).order('created_at DESC')
    @turns_rating = @turns.map(&:turn_rating).flatten.compact
    @turns_rating = @turns_rating
    if !@turns_rating.present?
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      return redirect_to dash_admin_users_path
    end
    @rating = {
      ges: @turns_rating.map(&:ges).inject(:+) / @turns_rating.length,
      body: @turns_rating.map(&:body).inject(:+) / @turns_rating.length,
      creative: @turns_rating.map(&:creative).inject(:+) / @turns_rating.length,
      spontan: @turns_rating.map(&:spontan).inject(:+) / @turns_rating.length,
      rhetoric: @turns_rating.map(&:rhetoric).inject(:+) / @turns_rating.length
    }
    userss = @teams.map do |team| 
      team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    end
    userss = userss.flatten
    raw_result = users_ratings userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    @average_team_rating = @ratings.attributes.slice("ges", "body","rhetoric", "spontan").values.map(&:to_i).inject(:+) / 40 if @ratings.present?
    @length = raw_result.length
  end

  def compare_with_team
    @users = @admin.users
    @turns = @admin.turns.where(admin_turn: true).order('created_at ASC')
    @team = Team.find(params[:team_id])
    @turns_rating = @turns.map(&:turn_rating).flatten.compact
    @turns_rating = @turns_rating.last(7)
    if !@turns_rating.present? || !@team.users.present?
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      return redirect_to dash_admin_users_path
    end
    userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings userss.to_a.push(@admin)
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    @ratings = @team.team_rating
    @reviewed_videos = @turns.where.not(recorded_pitch: nil).order('created_at DESC')
    @average_team_rating = @ratings.attributes.slice("ges", "body","rhetoric", "spontan").values.map(&:to_i).inject(:+) / 40 if @ratings.present?
    @three_records, @current_rating = find_index_and_siblings(@result,current_admin.id) if @result.present?
    @length = raw_result.length
  end

  def compare_with_user
    @users = @admin.users
    @turns = @admin.turns.where(admin_turn: true).order('created_at DESC')
    @user = @admin
    @team = @user.teams.first
    @turns_rating = @turns.map(&:turn_rating).flatten.compact
    @turns_rating = @turns_rating
    @user1 = User.find(params[:compare_user_id])
    @turns_rating2 = @user1.turn_ratings
    if !@turns_rating2.present? && !@turns_rating.present?
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      return redirect_to dash_admin_users_path
    end
    @userss = @admin.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings @userss.to_a.push(@admin)
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    @three_records, @current_rating = find_index_and_siblings(@result,@admin.id) if @result.present?
    @length = raw_result.length
    @reviewed_videos = @turns.where.not(recorded_pitch: nil).order('created_at DESC')
  end 

  def compare_user_stats
    @users = @admin.users
    @turns = @user.turns
    @turns_rating = @user.turn_ratings
    @user1 = User.find(params[:compare_user_id])
    @reviewed_videos = @turns.where.not(recorded_pitch: nil).order('created_at DESC')
    @turns_rating2 = @user1.turn_ratings
    if !@turns_rating2.present? && !@turns_rating.present?
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      return redirect_to dash_admin_users_path
    end
    @rating = @turns_rating.select("AVG(turn_ratings.body) AS body, AVG(turn_ratings.creative) AS creative, AVG(turn_ratings.spontan) AS spontan, AVG(turn_ratings.ges) AS ges, AVG(turn_ratings.rhetoric) AS rhetoric")[0]
    @turns_rating = @turns_rating.order('created_at DESC')
    @userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings @userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    @three_records, @current_rating = find_index_and_siblings(@result,params[:user_id]) if @result.present?
    @length = raw_result.length
  end

  def filter_videos
    if(params[:team_id].present?)
      @team = Team.find(params[:team_id])
      @users = @team.users
      @turns = @users.map(&:turns).flatten!
    elsif params[:user_id].present?
      @user = User.find(params[:user_id])
      @turns = @user.turns
    else
      @turns = @admin.turns.where.not(recorded_pitch: nil)
    end
    @result = @turns.present? ? json_convert(@turns, params[:sort_by]) : []
    response = render_to_string 'dash_admin/videos', layout: false,locals: {delete: true}
    render json: {turns_html:  response, turns: @result.each_slice(6), users: @users}
  end

  def get_teams
    render json: current_admin.teams.map{|t| {id: t.id, name: t.name}}.to_json
  end
    
  
    
  def verification
    @token = params[:token]     
  end

  def create_basket
    if(params[:basket][:type]== "objection") 
      current_admin.objection_baskets.new(name: params[:basket][:name]).save
      redirect_to dash_admin_objections_path
    else
      current_admin.catchword_baskets.new(name: params[:basket][:name]).save
      redirect_to dash_admin_catchwords_path
    end
  end

  def delete_basket
    CatchwordsBasket.find(params[:basket_id]).destroy
    redirect_to dash_admin_catchwords_path
  end

  def delete_objection_basket
    ObjectionsBasket.find(params[:basket_id]).destroy
    redirect_to dash_admin_objections_path
  end

  def billing
    Stripe.api_key = 'sk_test_zPJA7u8PtoHc4MdDUsTQNU8g'
    @credit_cards= @admin.cards.all
    begin
     @invoice = Stripe::Invoice.list({
                                       customer: @admin.stripe_id
                                   })
    rescue => e
      flash[:error] = "Error in fetching invoices"
    end

    # @invoice =@admin.invoices.all
    # @invoices= Stripe::InvoiceItem.retrieve(
    #    Invoice.where(stripe_invoice_id: @invoice.id)  
    # )
    # Invoice.create(plan_id: @invoice.values[1][0].id , 
    #   invoice_interval: @invoice.values[1][0].lines.data[0].plan.interval ,
    #   invoice_currency:@invoice.values[1][0].lines.data[0].plan.currency  ,
    #   amount_paid: @invoice.values[1][0].lines.data[0].plan.amount )

    
  end
  
  private
    def is_activated
      @admin = current_admin
      # if @admin && !@admin.activated
      #   flash[:danger] = 'Du bist noch nicht aktiviert!'
      #   sign_out @admin
      #   redirect_to root_path
      # end
    end
    def set_admin
      @admin = current_admin
      @teams = @admin.teams
    end

    def users_ratings(users)
      result = []
      users.map do |user|
        hash = {user: user,rating: {ges: 0,body: 0, spontan: 0, creative: 0, rhetoric: 0}, places: {gold: user[:gold_count], silver: user[:silver_count], bronze: user[:bronze_count]}}
        ratings = user.turn_ratings
        length = ratings.length
        hash[:rating][:ges] = (ratings.pluck(:ges).compact.inject(:+).to_f / length ) if length > 0
        hash[:rating][:spontan] = (ratings.pluck(:spontan).compact.inject(:+).to_f / length ) if length > 0
        hash[:rating][:creative] = (ratings.pluck(:creative).compact.inject(:+).to_f / length ) if length > 0
        hash[:rating][:rhetoric] = (ratings.pluck(:rhetoric).compact.inject(:+).to_f / length ) if length > 0
        hash[:rating][:body] = (ratings.pluck(:body).compact.inject(:+).to_f / length ) if length > 0
        hash[:rating][:average] =  (hash[:rating][:ges] + hash[:rating][:spontan] + hash[:rating][:creative] + hash[:rating][:rhetoric] + hash[:rating][:body]) / 5
        result.push(hash)
      end
      return result
    end

    def find_index_and_siblings(result, user_id)
      index = result.index{|record| record if record[:user].id == user_id.to_i}
      index = result.index{|record| record if record[:user].id == user_id.to_i} if index.nil?
      if index.nil?
        current_user = result.first 
      else
        current_user = result[index]
      end
      if index == 0 or index.nil?
        three_records = {"#{1}": result[0],"#{2}": result[1], "#{3}": result[3]}
      elsif index == result.length 
        three_records = {"#{index-1}": result[index-2],"#{index}": result[index], "#{index+1}": result[index]}
      else
        three_records = {"#{index}": result[index-1],"#{index+1}": result[index], "#{index+2}": result[index+1]}
      end
      [three_records, current_user]
    end

    def set_team
      @team = Team.find(params[:team_id])
    end
    
    def set_user
      @user = User.find(params[:user_id])
    end


    def html_to_jpg html_content, team_id
      kit = IMGKit.new(html_content, quality: 5)
      kit.stylesheets << "#{Rails.root}/public/css/png.css"
      dirname = File.dirname(Rails.root + "public/pngs/teams/#{team_id}/image")
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
      kit
    end

    def to_file(kit, team_id)
      # title = SecureRandom.urlsafe_base64(nil, false)
      title = "Peter Pitch Tabelle Team Vertrieb"
      url = Rails.root.to_s + "/public/pngs/teams/#{team_id}/" + "#{title}.png"
      file = kit.to_file(url)
      url = "/pngs/teams/#{team_id}/" + "#{title}.png"
      url
    end

    def skip_action?
      (params[:token]) ? true : false  
    end
    def resolve_layout
      case action_name
      when "team_stats_share"
        "share"
      else
        "dash_admin"
      end
    end

end
