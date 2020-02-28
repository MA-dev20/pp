class UserRatingCriterium < ApplicationRecord
  belongs_to :user
  belongs_to :rating_criteria, optional: true
  belongs_to :game
end
