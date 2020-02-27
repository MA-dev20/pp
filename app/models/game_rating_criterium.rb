class GameRatingCriterium < ApplicationRecord
  belongs_to :team
  belongs_to :custom_rating  
  belongs_to :rating_criteria, optional: true
  belongs_to :game
end
