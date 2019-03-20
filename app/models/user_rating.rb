class UserRating < ApplicationRecord
  belongs_to :user
    
  def self.rating_order
    order('ges desc')
  end
end
