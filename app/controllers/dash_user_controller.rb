class DashUserController < ApplicationController
  before_action :authenticate_user!, :set_user, :is_activated
	
  def stats
	@user_rating = @user.user_rating
	@turns = @user.turns
	@turn_ratings = @user.turn_ratings
	@chartdata = []
	@date = @turn_ratings.first&.created_at.beginning_of_day
	@days = 1
	@turn_ratings.each do |t|
	 @chartdata << {turn_id: t.turn_id, date: t.created_at.strftime("%d.%m.%Y"), ges: t.ges, spontan: t.spontan, creative: t.creative, body: t.body, rhetoric: t.rhetoric}
	 bod = t.created_at.beginning_of_day
     if @date != bod
		@date = bod
		@days = @days + 1
	 end
	end
  end
	
  def videos
	@turns = Turn.where.not(recorded_pitch: nil, released: false)
	@result = []
	@turns.each do |t|
	  @word = t.word
	  if @word
		@result << {turn_id: t.id, favorite: t.favorite, pitch_url: t.recorded_pitch.thumb.url, word: @word.name, date: t.created_at, rating: t.turn_rating.ges}
	  else
		@result << {turn_id: t.id, favorite: t.favorite, pitch_url: t.recorded_pitch.thumb.url, date: t.created_at, rating: t.turn_rating.ges}
	  end
	end
  end
	
  def video
	@turn = Turn.find(params[:turn_id])
	@comments = @turn.comments
	@admin = @user.admin
  end

  private
	def set_user
	  @user = current_user
	end
	def is_activated
	  if @user && @user.accepted
		 flash[:activated] = 'Dein Admin hat dich noch nicht freigeschaltet!'
		 sign_out @user
		 redirect_to root_path
	  end
	end
end