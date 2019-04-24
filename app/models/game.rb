class Game < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable
  belongs_to :admin
  belongs_to :team
  belongs_to :turn, required: false
    
  has_one :game_rating, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings
  has_many :users, through: :turns
  after_update_commit do
    NotificationBroadcastJob.perform_later(self)
  end

end
