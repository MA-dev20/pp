class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :trackable
  belongs_to :admin
    
  has_one :user_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
    
  mount_uploader :avatar, PicUploader
  
  enum status: [:accepted , :rejected , :pending ]

end
