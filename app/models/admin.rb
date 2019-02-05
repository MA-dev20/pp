class Admin < ApplicationRecord
    
  has_many :games, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy

  has_secure_password
    
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader

  before_save { self.email = email.downcase }
end
