class CustomRatingCriterium < ApplicationRecord
  belongs_to :turn
  belongs_to :game
  belongs_to :user
  belongs_to :admin
  belongs_to :rating_criteria
end
