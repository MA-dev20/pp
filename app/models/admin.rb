class Admin < ApplicationRecord
    
  has_many :games, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :root_admins, dependent: :destroy
  has_many :roots, through: :root_admins
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy

  has_secure_password
    
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader
    
  validates :fname, :lname, :street, :city, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :employees, numericality: { only_integer: true, less_than: 1000000, greater_than: 0 }
  validates :zipcode, numericality: { only_integer: true, less_than: 100000, greater_than: 10000 }, presence: true
    
  before_save { self.email = email.downcase }
end
