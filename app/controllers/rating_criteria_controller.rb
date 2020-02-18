class RatingCriteriaController < ApplicationController
  before_action :authenticate
  before_action :set_custom_rating, only: :create

  def create
    @rating_criteria = @custom_rating.rating_criteria.new(rating_criteria_params)
    if @rating_criteria.save
        redirect_to dash_admin_custom_rating_path(@custom_rating.id)
    else
        flash[:word_name] = 'Gib einen Namen an!'
    end
  end

  def destroy
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

end
