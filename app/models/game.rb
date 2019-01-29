class Game < ApplicationRecord
  belongs_to :admin
  belongs_to :team
    
  has_one :game_rating, dependent: :destroy
  has_many :turns, dependent: :destroy
end
