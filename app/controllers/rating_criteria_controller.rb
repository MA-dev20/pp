class RatingCriteriaController < ApplicationController
  before_action :authenticate
  before_action :set_custom_rating, only: [:create, :destroy]
  before_action :set_vars, only: [:create_admin_rating, :create_user_rating]

  def create
    if params[:criteria][:name] == ""
        flash[:rating_name] = "Gib einen Namen an!"
    else
        @rating_criteria = @custom_rating.rating_criteria.new(rating_criteria_params)
        unless @rating_criteria.save
          flash[:rating_name] = "Konnte nicht speichern!"
        end
    end
    redirect_to dash_admin_custom_rating_path(@custom_rating.id)
  end

  def create_admin_rating
    @admin = current_admin
    @game = @turn.game
    @custom_rating = @game.custom_rating
    # @turn.custom_rating_id = @custom_rating.id
    rating_names = params[:rating].keys
    rating_values = params[:rating].values
    rating_int_values = rating_values.map(&:to_i)
    @ges = rating_int_values.inject(0, :+) / rating_int_values.count

    params[:rating].each do |key, value|
      @rating_criteria = @custom_rating.rating_criteria.find_by(name: key)
      @turn.custom_rating_criteria.new(rating_criteria_id: @rating_criteria.id, admin_id: @admin.id, game_id: @game.id, name: key, value: value).save!
    end
    @ges_rating_criteria = @turn.custom_rating_criteria.new(admin_id: @admin.id, game_id: @game.id, name: 'ges', value: @ges)

    ratings_count = @turn.custom_rating_criteria.count / @custom_rating.rating_criteria.count
    # @custom_rating.rating_criteria.each_with_index do |rating, index|
    #   @custom_rating.rating_criteria.find_by(name: rating_names[index]).update(value: rating_values[index])
    # end

    # @users_custom_rating = UsersCustomRating.new(admin_id: @admin.id, custom_rating_id: @custom_rating.id)

    debugger
    if @ges_rating_criteria.save && ratings_count == (@game.turns.where(status: 'accepted').count - 1)
      @game.update(state: 'rating')
      redirect_to gma_rating_path
      return
    elsif @ges_rating_criteria.save
      ActionCable.server.broadcast "count_#{@game.id}_channel", game_state: 'rate', counter: ratings_count.to_s + '/' + (@game.turns.where(status: 'accepted').count - 1).to_s + ' haben bewertet!'
      redirect_to gma_rated_path
    else
      redirect_to gma_rate_path
    end
  end

  def create_user_rating
    @user = current_user
    @game = @turn.game
    @custom_rating = @game.custom_rating
    # @turn.custom_rating_id = @custom_rating.id
    rating_names = params[:rating].keys
    rating_values = params[:rating].values
    rating_int_values = rating_values.map(&:to_i)
    @ges = rating_int_values.inject(0, :+) / rating_int_values.count

    params[:rating].each do |key, value|
      @rating_criteria = @custom_rating.rating_criteria.find_by(name: key)
      @turn.custom_rating_criteria.new(rating_criteria_id: @rating_criteria.id, user_id: @user.id, game_id: @game.id, name: key, value: value).save!
    end
    @ges_rating_criteria = @turn.custom_rating_criteria.new(user_id: @user.id, game_id: @game.id, name: 'ges', value: @ges)

    ratings_count = @turn.custom_rating_criteria.where.not(rating_criteria_id: nil).count / @custom_rating.rating_criteria.count

    # @custom_rating.rating_criteria.each_with_index do |rating, index|
    #   @custom_rating.rating_criteria.find_by(name: rating_names[index]).update(value: rating_values[index])
    # end

    # @users_custom_rating = UsersCustomRating.new(admin_id: @admin.id, custom_rating_id: @custom_rating.id)

    debugger
    if @ges_rating_criteria.save && ratings_count == (@game.turns.where(status: 'accepted').count - 1)
      @game.update(state: 'rating')
      redirect_to gma_rating_path
      return
    elsif @ges_rating_criteria.save
      ActionCable.server.broadcast "count_#{@game.id}_channel", game_state: 'rate', counter: ratings_count.to_s + '/' + (@game.turns.where(status: 'accepted').count - 1).to_s + ' haben bewertet!'
      redirect_to gma_rated_path
    else
      redirect_to gma_rate_path
    end
  end

  def destroy
    rating_criteria = RatingCriterium.find(params[:criteria_id])
    if @custom_rating.rating_criteria.delete(rating_criteria)
        flash[:success] = 'Criteria aus Liste gelöscht!'
    else
        flash[:danger] = 'Konnte criteria NICHT löschen!'
    end
    redirect_to dash_admin_custom_rating_path(@custom_rating.id)
  end

  private

  def rating_criteria_params
    params.require(:criteria).permit(:name)
  end

  def authenticate
    if current_admin.nil? && current_root.nil?
      flash[:danger] = "Bitte logge dich ein!"
      redirect_to new_session_path(admin)
      return
    end
  end

  def set_custom_rating
    @custom_rating = CustomRating.find(params[:rating_id])
  end

  def set_vars
    @turn = Turn.find_by(id: params[:turn_id])
    @turn.update(played: true)
  end
  
  # def rating_params
  #   params.require(:rating).permit(:body, :creative, :rhetoric, :spontan)
  # end
end
