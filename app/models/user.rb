class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :trackable
  belongs_to :admin
  validates :email, presence: true
  has_one :user_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :team_users, dependent: :destroy
  has_many :teams, through: :team_users, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
  has_many :custom_rating_criteria, dependent: :destroy
  
  mount_uploader :logo, PicUploader
    
  mount_uploader :avatar, PicUploader
  
  enum status: [:accepted , :rejected , :pending ]


  def encrypt text
    text = text.to_s unless text.is_a? String
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end

  def decrypt text
    salt, data = text.split "$$"
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(Rails.application.secret_key_base).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    crypt.decrypt_and_verify data
  end
end
