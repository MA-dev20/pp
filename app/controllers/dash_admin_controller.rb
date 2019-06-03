class DashAdminController < ApplicationController
  before_action :authenticate_admin!, :set_admin , unless: :skip_action?
  before_action :set_team, only: [:games, :team_stats, :team_users, :user_stats, :compare_user_stats,:team_stats_share]
  before_action :set_user, only: [:user_stats, :compare_user_stats]
  skip_before_action :check_expiration_date, only: :billing

  include ActionView::Helpers::NumberHelper
  layout :resolve_layout
  
  def index
    if params[:team_id]
      @team = Team.find(params[:team_id])
    end
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

  def video_tool
    @users = @admin.users
    @turns = Turn.where.not(recorded_pitch:  nil)
    @result = json_convert(@turns)
  end

  def turn_show
    @turns_rating = TurnRating.find(params[:turn_id])
    @turn = @turns_rating.turn
    @user = @turn.user
    @turn.review
    @gamerating = GameRating.where(game_id: @turns_rating.game_id).first
    render :show_turn
  end

  def get_words
    render json: current_admin.has_or_create_basket_for_words.map{|t| {id: t.id, name: t.name.nil? ? " " : t.name}}.to_json
  end

  def add_word
    @word = Word.find_by_name(params[:name])
    @already = false
    if @word.present?
      if @admin.catchword_baskets.find(params[:basket_id]).words.include?(@word)
        @already = true        
      else
        @admin.catchword_baskets.find(params[:basket_id]).words << @word 
      end
    else
      @word = @admin.catchword_baskets.find(params[:basket_id]).words.create(name: params[:name])
    end
    @count = @admin.catchword_baskets.find(params[:basket_id]).words.count
    @id = params[:basket_id]
    respond_to do |format|
      format.js do
        render :add_word
      end
    end
  end

  def remove_word
    @admin.catchword_baskets.find(params[:basket_id]).words.delete(Word.find(params[:word_id]))
    render json: {count: @admin.catchword_baskets.find(params[:basket_id]).words.count }
  end

  def teams
  end

  def catchwords
    @baskets = @admin.catchword_baskets 
  end
    
  def team_stats
    @users = @admin.users
    @rating = @team.team_rating
    @gameratings = @team.game_ratings.last(7)
    @count = 1
    if !@rating
      flash[:pop_up] = "Ups, für dieses Team liegen noch keine Statistiken vor.;- Da müsst ihr wohl erst noch eine Runde spielen. -;Let's Play"
      redirect_to dash_admin_teams_path
    end

    userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    # if @result.present?
    #   if @result.count >= 3
    #     @three_records = @result
    #   else
    #     @three_records, current_rating = find_index_and_siblings(@result, current_admin.id) if @result.present?
    #   end
    # end
    @length = raw_result.length
    @turns = current_admin.turns
    if params[:team2_id]
      @team2 = Team.find(params[:team2_id])
      @gameratings2 = @team2.game_ratings.last(7)
    end
  end

  def team_stats_share
    userss = @team.users.includes(:turn_ratings).distinct
    raw_result = users_ratings userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
  end
    
  def users
    if params[:team_id]
      @team = Team.find(params[:team_id])
      @users = @team.users
    else
      @users = @admin.users
    end
  end
    
  def user_stats
    @users = @admin.users
    @turns = @user.turns
    @reviewed_videos = @turns.where.not(recorded_pitch: nil, click_time: nil).order('click_time DESC').first(2)
    @turns_rating = @user.turn_ratings
    if !@turns_rating
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      redirect_to dash_admin_users_path
    end
    @rating = @turns_rating.select("AVG(turn_ratings.body) AS body, AVG(turn_ratings.creative) AS creative, AVG(turn_ratings.spontan) AS spontan, AVG(turn_ratings.ges) AS ges, AVG(turn_ratings.rhetoric) AS rhetoric")[0]
    userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    @ratings = @team.team_rating
    @average_team_rating = @ratings.attributes.slice("ges", "body","rhetoric", "spontan").values.map(&:to_i).inject(:+) / 40 if @ratings.present?
    # if @result.present?
    #   if @result.count >= 3
    #     @three_records = @result
    #   else
        @three_records, @current_rating = find_index_and_siblings(@result,params[:user_id]) if @result.present?
    #   end
    # end

    @length = raw_result.length
  end  

  def filter_videos
    if(params[:team_id].present?)
      @team = Team.find(params[:team_id])
      @turns = @team.users.map(&:turns).flatten!
    elsif params[:user_id].present?
      @user = User.find(params[:user_id])
      @turns = @user.turns
    else
      @turns = @teams.map(&:users).flatten!.map(&:turns).flatten!
    end
    @result = json_convert(@turns)
    response = render_to_string 'dash_admin/videos', layout: false
    render json: {turns_html:  response, turns: @result}
  end

  def compare_user_stats
    @users = @admin.users
    @turns = @user.turns
    @turns_rating = @user.turn_ratings.last(7)
    @user1 = User.find(params[:compare_user_id])
    @turns_rating2 = @user1.turn_ratings.last(7)
    rating = @user.turn_ratings
    rating2 = @user1.turn_ratings
    if !rating.present? && !rating2.present?
      flash[:danger] = 'Noch keine bewerteten Spiele!'
      return redirect_to dash_admin_users_path
    end
    @rating = rating.select("AVG(turn_ratings.body) AS body, AVG(turn_ratings.creative) AS creative, AVG(turn_ratings.spontan) AS spontan, AVG(turn_ratings.ges) AS ges, AVG(turn_ratings.rhetoric) AS rhetoric")[0]
    @userss = @team.users.select(%Q"#{Turn::TURN_QUERY}").includes(:turn_ratings).distinct
    raw_result = users_ratings @userss
    @result = raw_result.sort_by {|u| -u[:rating][:average]}
    # if @result.present?
    #   if @result.count >= 3
    #     @three_records = @result
    #   else
        @three_records, @current_rating = find_index_and_siblings(@result,params[:user_id]) if @result.present?
    #   end
    # end

    @length = raw_result.length
  end

  def get_teams
    render json: current_admin.teams.map{|t| {id: t.id, name: t.name}}.to_json
  end
    
  def account
  end
    
  def verification
    @token = params[:token]     
  end

  def create_basket
    current_admin.catchword_baskets.new(name: params[:basket][:name]).save
    redirect_to dash_admin_catchwords_path
  end

  def delete_basket
    CatchwordsBasket.find(params[:basket_id]).destroy
    redirect_to dash_admin_catchwords_path
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
    def set_admin
      @admin = current_admin
      @teams = @admin.teams
    end

    def users_ratings(users)
      result = []
      users.map do |user|
        hash = {user: user,rating: {ges: 0,body: 0, spontan: 0, creative: 0, rhetoric: 0}, places: {gold: user.gold_count, silver: user.silver_count, bronze: user.bronze_count}}
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
      index = result.index{|record| record if record[:user].admin_id == user_id.to_i} if index.nil?
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
      title = SecureRandom.urlsafe_base64(nil, false)
      url = Rails.root.to_s + "/public/pngs/teams/#{team_id}/" + "#{title}.png"
      file = kit.to_file(url)
      url = "/pngs/teams/#{team_id}/" + "#{title}.png"
      url
    end

    def json_convert(turns)
      result = []
      turns.each do |t|
        if t.turn_rating.present? and t.recorded_pitch.present?
          turn = JSON.parse(t.to_json(include: [:turn_rating]))
          turn["rating"] = number_with_precision(t.turn_rating.slice("creative", "body","rhetoric", "spontan").values.map(&:to_f).inject(:+) / 40, precision: 1).to_f if t.turn_rating.present?
          turn["word"] = t.word.name if t.word.present?
          turn["name"] = t.user.fname + ' ' + t.user.lname if t.user.present?
          turn["duration"] = t.recorded_pitch_duration.to_minutes if t.recorded_pitch_duration.present?
          turn["time"] = t.created_at.strftime("%d.%m.%Y")
          turn["recorded_pitch_url"] = t.recorded_pitch.url if t.recorded_pitch.present?
          result.push(turn)
        end
      end
      result
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
