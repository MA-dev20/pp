class Admin < ApplicationRecord
  include Basket
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
  has_many :invoices, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :catchword_baskets , class_name: "CatchwordsBasket", dependent: :destroy
  has_many :objection_baskets , class_name: "ObjectionsBasket", dependent: :destroy
  has_many :videos, dependent: :destroy


  enum plan_type: [:year , :month, :trial]
  
  
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader
 
  #########Fields Validation On Update##################
  # validates_format_of :lname,   format:{ with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/ },length: {minimum: 3 , maximum: 16} , allow_blank: true, on: :update 
  # validates_format_of :password, length: {minimum: 6 , maximum: 16}, allow_blank: true, on: :update 
  # validates_format_of :password_confirm,length: {minimum: 6 , maximum: 16}, allow_blank: true, on: :update 
  # validates_format_of :company_name,  format:{ with: /\A[a-zA-Z]+(?: [a-zA-Z]+)?\z/ },length: {maximum: 40} , allow_blank: true, on: :update 
  # validates_format_of :street, format:{ with: /([- ,\/0-9a-zA-Z]+)/ },length: {maximum: 50} , allow_blank: true, on: :update 
  # validates_format_of :city, format:{ with: /([- ,\/0-9a-zA-Z]+)/ },length: {maximum: 50} , allow_blank: true, on: :update 
  # validates_format_of :zipcode, format:{ with:  /[0-9_,+#-]/ },length: {maximum: 50} , allow_blank: true, on: :update 



  #########Call-Back for Stripe#########################
  after_create :create_stripe_customer

  #########Call-back for Sign-in Expiration Date###########
  def devise_mailer
    AdminsDeviseMailer
  end
  def create_stripe_customer
Stripe.api_key = 'sk_test_zPJA7u8PtoHc4MdDUsTQNU8g'

    customer = Stripe::Customer.create(
      :email => self.email,
    )
    self.stripe_id =  customer.id
    self.plan_type= "trial"
    self.save
  end

  def expiry
    created_at + 14.days
  end

  ##########################Update Subscription for year################

  def upgrade_subscription_year(user)
    @admin = self
    if self.plan_type == 'year'
      year_amount = (7.17*100)*12
      plan =(year_amount.to_i)
   
    end
    begin
      @plan =Stripe::Plan.retrieve(1.to_s +  self.plan_type)
    rescue => e
      if (e.present?)
        @plan = Stripe::Plan.create({
                                        amount: plan,
                                        interval: self.plan_type,
                                        product: {
                                            name: 1.to_s + "_" + self.plan_type
                                        },
                                        currency: 'eur',
                                        id: 1.to_s + "_" + self.plan_type
                                    })
      end
    end

    self.plans.create(admin_id: self.id, stripe_plan_id: @plan.id , amount:@plan.id.amount, user_id:user.id)
    begin
    @subscription = Stripe::Subscription.create({
                                                    customer: self.stripe_id,
                                                    items: [
                                                        {
                                                            plan:  @plan.id
                                                        }
                                                    ]
                                                })
    self.subscriptions.create(admin_id: self.id, plan_id: self.plan_id, subscription_id:@subscription.id, user_id:user.id)
    rescue => e
      if (e.present?)
        Rails.logger.info  "Stripe Error: #{e.message}"
      end
    end

  end

  ########################## Update Subscription for Month ######################
  def upgrade_subscription
    @admin = self
    if self.plan_type == 'month'
      monthy_amount = 8.85*100
      plan =(monthy_amount.to_i) * self.plan_users.to_i
    end
    begin
      @plan =Stripe::Plan.retrieve( self.plan_users.to_s+ "_" + self.plan_type.to_s )
    rescue => e
      if (e.present?)
        @plan = Stripe::Plan.create({
                                        amount: plan,
                                        interval:  self.plan_type,
                                        product: {
                                            name: self.plan_users.to_s+ "_" + self.plan_type.to_s
                                        },
                                        currency: 'eur',
                                        id: self.plan_users.to_s+ "_" + self.plan_type.to_s
                                    })
      end
    end
    self.plan_id = @plan.id
    self.save

    begin
      d = Time.now.end_of_month + 1.day
      @subscription = Stripe::Subscription.update(
                                          @admin.admin_subscription_id,{

                                                plan:  @plan.id
                                        })
      self.admin_subscription_id = @subscription.id
      self.save

    rescue => e
      Rails.logger.info  "Stripe Error: #{e.message}"
      end
  end

  def reset_pw
    self.reset_pw_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.where(reset_pw_token: random_token).exists?
    end
  end


  end

