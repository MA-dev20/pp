class Team < ApplicationRecord
  belongs_to :admin
    
  has_one :team_rating, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :game_ratings, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
end
