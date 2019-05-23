class RatingsController < ApplicationController
  before_action :set_vars
    
  def new
  end
    
  def create
    @admin = current_admin
    @game = @turn.game
    @rating = @turn.ratings.new(rating_params)
    @rating.ges = (@rating.body + @rating.creative + @rating.rhetoric + @rating.spontan) / 4
    @rating.admin_id = @admin.id
    if @rating.save && @turn.ratings.count == (@game.turns.where(status: 'accepted').count - 1)
      @game.update(state: 'rating')
      redirect_to gma_rating_path
      return
    elsif @rating.save
      ActionCable.server.broadcast "count_#{@game.id}_channel", game_state: 'rate', counter: @turn.ratings.count.to_s + '/' + (@game.turns.where(status: 'accepted').count - 1).to_s + ' haben bewertet!'
      redirect_to gma_rated_path
    else
      redirect_to gma_rate_path
    end
  end
    
  def new_user
  end
    
  def create_user
    @user = current_user
    @game = @turn.game
    @rating = @turn.ratings.new(rating_params)
    @rating.ges = (@rating.body + @rating.creative + @rating.rhetoric + @rating.spontan) / 4
    @rating.user_id = @user.id
    if @rating.save && @turn.ratings.count == (@game.turns.where(status: 'accepted').count - 1)
      @game.update(state: 'rating')
      redirect_to gmu_rated_path
      return
    elsif @rating.save
      ActionCable.server.broadcast "count_#{@game.id}_channel", game_state: 'rate', counter: @turn.ratings.count.to_s + '/' + (@game.turns.where(status: 'accepted').count - 1).to_s + ' haben bewertet!'
      redirect_to gmu_rated_path
      return
    else
      redirect_to gmu_rate_path
      return
    end
  end
  private
    def set_vars
      @turn = Turn.find_by(id: params[:turn_id])
      @turn.update(played: true)
    end
    
    def rating_params
      params.require(:rating).permit(:body, :creative, :rhetoric, :spontan)
    end
end
