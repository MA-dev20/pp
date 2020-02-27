class TurnRatingCriterium < ApplicationRecord
  belongs_to :rating_criteria, required: false
  belongs_to :game
  belongs_to :user, required: false
  belongs_to :admin, required: false
  belongs_to :turn
  belongs_to :custom_rating

  #methhods call with new
  TurnRatingCriterium.class_eval do 
    def findUser
      if user_id
        User.find(user_id)
      else
        Admin.find(admin_id)
      end
    end   
  end
end
