class TeamRating < ApplicationRecord
  belongs_to :team
    
  def self.rating_order
    order('ges desc')
  end
end
