class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable, :recoverable, :rememberable, :validatable, :trackable
    
  has_many :games, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
    
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader

end
