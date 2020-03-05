class CustomRatingController < ApplicationController
  before_action :set_custom_rating, only: [:update, :destroy]

  def create
    if params[:rating][:name] == ""
      flash[:custom_rating] = "Gib einen Namen an!"
    else
      custom_rating = CustomRating.new(rating_params)
      if custom_rating.save
        redirect_to dash_admin_custom_rating_path(custom_rating.id)
        return 
      else
        flash[:custom_rating] = "Konnte nicht speichern!"
      end
    end
    redirect_to dash_admin_customize_path
  end

  def update
    if params[:rating][:name] == ""
        flash[:custom_rating_update] = "Gib einen Namen an!"
        redirect_to dash_admin_custom_rating_path(@custom_rating.id)
        return 
    elsif !@custom_rating.update(rating_params)
      flash[:danger] = "Konnte NICHT updaten!"
    end
    redirect_to dash_admin_customize_path
  end

  def destroy
    if @custom_rating.destroy
        flash[:success] = 'Criteria aus Liste gelöscht!'
    else
        flash[:danger] = 'Konnte criteria NICHT löschen!'
    end
    redirect_to dash_admin_customize_path
  end

  private

  def set_custom_rating
    @custom_rating = CustomRating.find(params[:rating_id])
  end

  def rating_params
    params.require(:rating).permit(:name, :admin_id)
  end
end
