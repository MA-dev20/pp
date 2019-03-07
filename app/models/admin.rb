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
  
  validates :email, uniqueness: true, presence: true

  # before_create :set_token





#   def set_token
#     self.vid_token = (0...50).map { ('a'..'z').to_a[rand(26)] }.join
#   end
 end

