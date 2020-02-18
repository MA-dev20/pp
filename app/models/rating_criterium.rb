class RatingCriterium < ApplicationRecord
  belongs_to :custom_rating

  validates_presence_of :name
end
