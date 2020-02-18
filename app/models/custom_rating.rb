class CustomRating < ApplicationRecord
  belongs_to :admin
  has_many :rating_criteria
end
