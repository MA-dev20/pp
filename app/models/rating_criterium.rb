class RatingCriterium < ApplicationRecord
  belongs_to :custom_rating
  has_many :custom_rating_criteria, foreign_key: 'rating_criteria_id', dependent: :nullify
  has_many :turn_rating_criteria, foreign_key: 'rating_criteria_id', dependent: :nullify
  has_many :user_rating_criteria, foreign_key: 'rating_criteria_id', dependent: :nullify
  has_many :game_rating_criteria, foreign_key: 'rating_criteria_id', dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :custom_rating_id
  validate :validate_rating_criteria_count, on: :create
  
  private

  def validate_rating_criteria_count
    self.errors.add(:base, "exceed maximum entry") if self.custom_rating.rating_criteria.size > 4
  end
end
