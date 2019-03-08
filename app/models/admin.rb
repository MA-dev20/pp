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

  validates :email, presence: true , on: :update
  validates :password, presence: true , on: :update
  validates :company_name, presence: true , on: :update
  validates :members, presence: true , on: :update







  before_create :create_stripe_customer
 
  def create_stripe_customer
    customer = Stripe::Customer.create(
      :email => self.email,
    )
    self.stripe_id =  customer.id
  end


end

