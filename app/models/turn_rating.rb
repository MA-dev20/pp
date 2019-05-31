class TurnRating < ApplicationRecord
  belongs_to :turn
  belongs_to :game
  belongs_to :user, required: false
  belongs_to :admin, required: false
end


#methods call with TurnRating.rating_order
TurnRating.instance_eval do
  def rating_order
    order('ges desc')
  end
end


#methhods call with new
TurnRating.class_eval do 
  def findUser
    if user_id
      User.find(user_id)
    else
      Admin.find(admin_id)
    end
  end   
end