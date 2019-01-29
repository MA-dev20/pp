class Turn < ApplicationRecord
  belongs_to :game
  belongs_to :word
    
  has_one :turn_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
end
