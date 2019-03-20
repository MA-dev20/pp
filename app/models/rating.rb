class Rating < ApplicationRecord
  belongs_to :turn
  belongs_to :user, required: false
  belongs_to :admin, required: false
 
  def findUser
    if user_id
      User.find(user_id)
    else
      Admin.find(admin_id)
    end
  end
    
  def self.rating_order
    order('ges desc')
  end
end
