class CustomRating < ApplicationRecord
  belongs_to :admin
  has_many :rating_criteria, dependent: :delete_all
  has_many :games
  has_many :turns
  has_many :turn_rating_criteria
  has_many :user_rating_criteria
  has_many :game_rating_criteria


  # has_many :users_custom_ratings
  # has_many :users, through: :users_custom_ratings

  before_destroy :delete_associated_objects

  private

  def delete_associated_objects
    self.games.each do |game|
      game.custom_rating_id = nil
      game.save
    end
    self.turns.each do |turn|
      turn.custom_rating_id = nil
      turn.save
    end
  end
end
