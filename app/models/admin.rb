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
  has_many :invoices, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  enum plan_type: [:year , :month]
  
  
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

  def create_stripe_customer
    customer = Stripe::Customer.create(
      :email => self.email,
    )
    self.stripe_id =  customer.id
    self.save
  end

  def expiry
    created_at + 14.days
  end
  ##########################Update Subscription for year################
  def upgrade_subscription_year(user)
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
                                            name: 1.to_s + self.plan_type
                                        },
                                        currency: 'eur',
                                        id: 1.to_s + self.plan_type 
                                    })
      end
    end
   
    self.plans.create(admin_id: self.id, stripe_plan_id: @plan.id , amount:@plan.id.amount, user_id:user.id)

    # self.plan_id = @plan.id
    # self.plan_users = 1
    # self.save
    begin
    Stripe::Subscription.retrieve(@admin.admin_subscription_id)
    @subscription = Stripe::Subscription.create(
                                        @admin.admin_subscription_id,{ 
                                        
                                        items: [  
                                            { 
                                              plan:  self.plan_id
                                            }
                                                ]
                                      })
    self.subscriptions.create(admin_id: self.id, plan_id: self.plan_id, subscription_id:@subscription.id, user_id:user.id)
    rescue => e
      if (e.present?)
      @subscription = Stripe::Subscription.create({ 
                                        customer: self.stripe_id,
                                        items: [  
                                            { 
                                              plan:  @plan.id
                                            }
                                                ]
                                      })
      self.subscriptions.create(admin_id: self.id, plan_id: self.plan_id,subscription_id:@subscription.id, user_id:user.id)
      end
    end

  end

  ########################## Update Subscription for Month######################
  def upgrade_subscription
    if self.plan_type == 'month'
      monthy_amount = 8.85*100
      plan =(monthy_amount.to_i) * self.plan_users.to_i
    # else
    #   year_amount = 7.17*100
    #   plan =(year_amount.to_i) * self.plan_users.to_i
    end
    begin
      @plan =Stripe::Plan.retrieve(self.plan_users +  self.plan_type)
    rescue => e
      if (e.present?)
        @plan = Stripe::Plan.create({
                                        amount: plan,
                                        interval: self.plan_type,
                                        product: {
                                            name: self.plan_users + self.plan_type
                                        },
                                        currency: 'eur',
                                        id: self.plan_users + self.plan_type 
                                    })
      end
    end
    self.plan_id = @plan.id
    self.plan_users = self.plan_users
    self.save
    begin
    Stripe::Subscription.retrieve(@admin.admin_subscription_id)
    @subscription = Stripe::Subscription.update(
                                        @admin.admin_subscription_id,{ 
                                        
                                        items: [  
                                            { 
                                              plan:  @plan.id,
                                              
                                            }
                                                ],
                                        billing_cycle_anchor: 1554383082
                                      })
      self.admin_subscription_id = @subscription.id
      self.save

    rescue => e
      if (e.present?)
      @subscription = Stripe::Subscription.create({ 
                                        customer: self.stripe_id,
                                        items: [  
                                            { 
                                              plan:  @plan.id,
                                            }
                                                ],
                                        billing_cycle_anchor: 1554383082
                                      })
        self.admin_subscription_id = @subscription.id
        self.save
      end
    end

  end


end

