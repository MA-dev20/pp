class CustomRating < ApplicationRecord
  belongs_to :admin
  has_many :rating_criteria
  # has_many :rating_criteria, class_name: 'RatingCriterium'
end
