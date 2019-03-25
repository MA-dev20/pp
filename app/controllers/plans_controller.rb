class PlansController < ApplicationController
  before_action :authenticate_admin!, :set_admin
  before_action :card_check, only: [:create]
  skip_before_action :check_expiration_date
  layout 'main'
  
  def create
    number_of_users= params[:admin]['plan_users']
    plan_type = params[:admin]['plan_type']
    if plan_type == 'month'
      monthy_amount = 8.85*100
      plan_month =(monthy_amount.to_i) * number_of_users.to_i
      create_plan(plan_month,plan_type,number_of_users)
    else
      year_amount = 7.17*100*12
      year_plan =(year_amount.to_i) * number_of_users.to_i
      create_plan(year_plan,plan_type,number_of_users)
    end
  end


  def create_plan(plan,plan_type,number_of_users)
    begin
      @plan =Stripe::Plan.retrieve(number_of_users.to_s + "_" + plan_type)
    rescue => e
      if (e.present?)
      @plan = Stripe::Plan.create({
                                     amount: plan,
                                     interval: plan_type,
                                     product: {
                                         name: number_of_users.to_s + "_" +plan_type
                                     },
                                     currency: 'eur',
                                     id: number_of_users.to_s + "_" +plan_type
                                 })
      end
    end
    @admin.update_attributes(plan_type: plan_type , plan_id: @plan.id, plan_users: number_of_users)
    create_subscripiton(@plan)
  end


  def create_subscripiton(plan)
    @subscription = Stripe::Subscription.create(
            {
              customer: @admin.stripe_id,
              items: [
                {
                  plan:  plan.id,
                }
              ]
            })

    @admin.update_attributes(admin_subscription_id:  @subscription.id )
    redirect_to dash_admin_billing_path
  end


  def set_admin
    @admin = current_admin
  end

  def card_check
    if !@admin.cards.exists? 
      redirect_to dash_admin_billing_path
      flash[:notice] ="Please enter your card first"
    end
  end

  
end
