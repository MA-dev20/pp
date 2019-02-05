class Game < ApplicationRecord
  belongs_to :admin
  belongs_to :team
  belongs_to :turn, required: false
    
  has_one :game_rating, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
    

end
