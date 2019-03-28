class Turn < ApplicationRecord
  belongs_to :game
  belongs_to :word
  belongs_to :user, required: false
  belongs_to :admin, required: false

  has_one :turn_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
    
  scope :playable, -> { where(play:true, played: false) }
    
  def findUser
    if user_id
      User.find(user_id)
    else
      Admin.find(admin_id)
    end
  end
end
