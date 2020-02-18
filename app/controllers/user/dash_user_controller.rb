class User::DashUserController < UsersController
	include ApplicationHelper
  include ActionView::Helpers::NumberHelper

	before_action :authenticate_user! 
	before_action :set_user
	layout 'dash_user'
	
	def stats
		if !@team.nil?
			@ratings = @team.team_rating
	    @average_team_rating = @ratings.attributes.slice("ges", "body","rhetoric", "spontan").values.map(&:to_i).inject(:+) / 40 if @ratings.present?
		end
    @turns_rating = @user.turn_ratings
    @current_rating = user_rating @user
    @reviewed_videos = @user.turns.where.not(recorded_pitch: nil).order('created_at DESC') 
    if !@turns_rating
      flash[:danger] = 'Noch kein bewerteten Pitch!'
      redirect_to dash_admin_users_path
    end
    @rating = @turns_rating.select("AVG(turn_ratings.body) AS body, AVG(turn_ratings.creative) AS creative, AVG(turn_ratings.spontan) AS spontan, AVG(turn_ratings.ges) AS ges, AVG(turn_ratings.rhetoric) AS rhetoric")[0]
	end

	def tool
    @turns = @user.turns.where.not(recorded_pitch: nil)
    @result = json_convert(@turns, "date")
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
    @admin_ratings = nil
    render  :turn
  end

  def account
  end

  def update_user
  	@user.attributes = (user_params)
  	if params[:user][:password].present? && (params[:user][:password] == params[:user][:password_confirmation])
  		@user.password = params[:user][:password]
  	elsif params[:user][:password].present? || params[:user][:password_confirmation].present?
  		flash[:error] = "Password Doesnot match"
  		return	redirect_to dash_user_account_path
  	end
  	@user.save!
  	flash[:success] = "Successfully updated"
  	redirect_to dash_user_account_path
  end

	def delete_video
    @turn = Turn.find(params[:turn_id])
    @turn.recorded_pitch.remove!
    @turn.save!
	end

  def filter_videos
    @turns = @user.turns
    @result = @turns.present? ? json_convert(@turns, params[:sort_by]) : []
    response = render_to_string 'videos', layout: false,locals: {delete: false}
    render json: {turns_html:  response, turns: @result.each_slice(6), users: @users}
  end

	private

	def set_user
		@user = current_user
		@teams = @user.teams
		@team = @teams.last
	end

	def user_rating user
		hash = {user: user,rating: {ges: 0,body: 0, spontan: 0, creative: 0, rhetoric: 0}}
    ratings = user.turn_ratings
    length = ratings.length
    hash[:rating][:ges] = (ratings.pluck(:ges).compact.inject(:+).to_f / length ) if length > 0
    hash[:rating][:spontan] = (ratings.pluck(:spontan).compact.inject(:+).to_f / length ) if length > 0
    hash[:rating][:creative] = (ratings.pluck(:creative).compact.inject(:+).to_f / length ) if length > 0
    hash[:rating][:rhetoric] = (ratings.pluck(:rhetoric).compact.inject(:+).to_f / length ) if length > 0
    hash[:rating][:body] = (ratings.pluck(:body).compact.inject(:+).to_f / length ) if length > 0
    hash[:rating][:average] =  (hash[:rating][:ges] + hash[:rating][:spontan] + hash[:rating][:creative] + hash[:rating][:rhetoric] + hash[:rating][:body]) / 5

    hash
	end

	def user_params
		params.require(:user).permit(:fname,:company_name,:lname,:street,:zipcode,:city,:email, :avatar , :logo)
	end
end
