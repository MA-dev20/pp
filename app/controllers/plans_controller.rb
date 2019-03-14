class PlansController < ApplicationController
    before_action :authenticate_admin!, :set_admin
    layout 'main'
   
    def create
    debugger
    @admin.update_columns(annually: :annually) 
    user= @admin.users.all.count
    a =8.85*100
    month =(a.to_i) *user
    b =7.17*100
    year = (b.to_i )* user
      if !@admin.annually.eql?(true)
        @plan= Stripe::Plan.create({
            amount:year,
            interval: 'year',
            product: {
              name: 'Admin' +  SecureRandom.hex(1) + 'User_Plan' +user.to_s ,
            },
            currency: 'eur',
            id: 'Admin' +  SecureRandom.hex(1) + 'User_Plan' +user.to_s,
          })
        @plans= @admin.plans.create(admin_id: @admin.id, amount: @plan.amount,
              product_name: @plan.product,interval: @plan.interval  ,currency: @plan.currency,
              stripe_plan_id: @plan.id)
          
        @subscription = Stripe::Subscription.create(
              {
                customer: @admin.stripe_id,
                items: [
                  {
                    plan:  @plan.id,
                  },
                ],
              })
        debugger
        @plans.build_subscription(stripe_subscription_id: @subscription.id , plan_id:  @plans.id ).save
              

        redirect_to dash_admin_billing_path
      else
        @plan= Stripe::Plan.create({
          amount: month,
          interval: 'month',
          product: {
            name: 'Admin' +  SecureRandom.hex(1) + 'User_Plan' +user.to_s,
          },
          currency: 'eur',
          id: 'Admin' +  SecureRandom.hex(1) + 'User_Plan' +user.to_s
        })

        @plans=@admin.plans.create(admin_id: @admin.id, amount: @plan.amount,
            product_name: @plan.product,interval: @plan.interval  ,currency: @plan.currency,
            stripe_plan_id: @plan.id)
            @subscription = Stripe::Subscription.create(
              {
                customer: @admin.stripe_id,
                items: [
                  {
                    plan:  @plan.id,
                  },
                ],
              })
        debugger
        @plans.build_subscription(stripe_subscription_id: @subscription.id , plan_id:  @plans.id ).save
        redirect_to dash_admin_billing_path
      end
    end


    def set_admin
    @admin = current_admin
    end
  
end
