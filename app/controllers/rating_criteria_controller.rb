class RatingCriteriaController < ApplicationController
  before_action :authenticate
  before_action :set_custom_rating, only: [:create, :destroy]

  def create
    if params[:criteria][:name] == ""
        flash[:rating_name] = "Gib einen Namen an!"
        redirect_to dash_admin_custom_rating_path(@custom_rating.id)
    else
        if @custom_rating.rating_criteria.count < 4
            @rating_criteria = @custom_rating.rating_criteria.new(rating_criteria_params)
            if @rating_criteria.save
                redirect_to dash_admin_custom_rating_path(@custom_rating.id)
            else
                flash[:rating_name] = "Konnte nicht speichern!"
            end
        else
            flash[:rating_name] = "Maximum four ratings allowed"
            redirect_to dash_admin_custom_rating_path(@custom_rating.id)
        end
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
end
