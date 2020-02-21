class RatingCriterium < ApplicationRecord
  belongs_to :custom_rating

  validates_presence_of :name
  validate :validate_rating_criteria_count, on: :create
  
  private

  def validate_rating_criteria_count
    self.errors.add(:base, "exceed maximum entry") if self.custom_rating.rating_criteria.size > 4
  end
end
