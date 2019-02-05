class User < ApplicationRecord
  belongs_to :admin
    
  has_one :user_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
    
  has_secure_password validations: false
    
  mount_uploader :avatar, PicUploader
    
  before_save { self.email = email.downcase }
end
