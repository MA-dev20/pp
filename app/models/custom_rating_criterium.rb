class CustomRatingCriterium < ApplicationRecord
  belongs_to :rating_criteria, required: false
  belongs_to :game
  belongs_to :user, required: false
  belongs_to :admin, required: false
  belongs_to :turn
end
