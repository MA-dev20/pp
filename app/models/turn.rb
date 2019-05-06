class Turn < ApplicationRecord
  belongs_to :game
  belongs_to :user, required: false
  belongs_to :admin, required: false
  belongs_to :word, required: false
  has_one :turn_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
  
  TURN_QUERY = 'users.*,(select count(*) from turns t1 where t1.user_id=users.id and place=1) as gold_count, (select count(*) from turns t1 where t1.user_id=users.id and place=2) as silver_count, (select count(*) from turns t1 where t1.user_id=users.id and place=3) as bronze_count'
    
  scope :playable, -> { where(play:true, played: false) }
    
  def findUser
    if user_id
      User.find(user_id)
    else
      Admin.find(admin_id)
    end
  end
end
