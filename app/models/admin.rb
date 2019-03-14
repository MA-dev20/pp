class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable, :recoverable, :rememberable, :validatable, :trackable
    
  #########Associations##################
  has_many :games, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :plans, dependent: :destroy


  
  
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader
 
  #########Fields Validation On Update##################
  validates :email, presence: true , on: :update
  validates :password, presence: true , on: :update
  validates :company_name, presence: true , on: :update
  validates :members, presence: true , on: :update

  #########Call-Back for Stripe#########################
  before_create :create_stripe_customer, :set_expiration_date

  #########Call-back for Sign-in Expiration Date###########

  def create_stripe_customer
    customer = Stripe::Customer.create(
      :email => self.email,
    )
    self.stripe_id =  customer.id
  end

  def set_expiration_date
    self.expiration =  Date.today + 13.days
  end

end

