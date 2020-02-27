class RatingCriterium < ApplicationRecord
  belongs_to :custom_rating
  has_many :custom_rating_criteria
  has_many :turn_rating_criteria
  has_many :user_rating_criteria
  has_many :game_rating_criteria

  validates_presence_of :name
  validate :validate_rating_criteria_count, on: :create
  
  private

  def validate_rating_criteria_count
    self.errors.add(:base, "exceed maximum entry") if self.custom_rating.rating_criteria.size > 4
  end
end
