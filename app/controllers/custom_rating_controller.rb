class CustomRatingController < ApplicationController
  before_action :set_custom_rating, only: [:update]

  def create
    custom_rating = CustomRating.new(rating_params)
    if custom_rating.save
      redirect_to dash_admin_custom_rating_path(custom_rating.id)
    else
      flash[:danger] = "Konnte Liste nicht speichern!"
    end
  end

  def update
    unless @custom_rating.update(basket_params)
      flash[:danger] = "Konnte Liste NICHT updaten!"
    end
    redirect_to dash_admin_customize_path
  end

  def destroy
  end

  private

  def set_custom_rating
    @custom_rating = CustomRating.find(params[:custom_rating_id])
  end

  def rating_params
    params.require(:rating).permit(:name, :admin_id)
  end
end
