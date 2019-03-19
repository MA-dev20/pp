class PlansController < ApplicationController
  before_action :authenticate_admin!, :set_admin
  skip_before_action :check_expiration_date
  layout 'main'
  
  def create

    @admin.update_columns(annually: :annually) 
    user= @admin.users.all.count
    a =8.85*100
    month =(a.to_i) * user
    b =7.17*100
    year = (b.to_i )* user
      if !@admin.annually.eql?(true)
        @plan= Stripe::Plan.create({
          amount:year,
          interval: 'year',
          product: {
            name: 'Admin'+  +SecureRandom.hex(1)+  'User_Plan' +user.to_s ,
          },
          currency: 'eur',
          id: 'Admin'+  +SecureRandom.hex(1)+  'User_Plan' +user.to_s ,
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
        
        @plans.build_subscription(stripe_subscription_id: @subscription.id , plan_id:  @plans.id ).save
        @invoice = Stripe::Invoice.list(limit: 3)
        @admin_invoice =Admin.where(stripe_id: @invoice.values[1][0].customer ).first
        @card=Card.where(stripe_custommer_id: @invoice.values[1][0].customer).first
  
        @admin_invoice.invoices.create(card_number:  @card.last_4_cards_digit ,
          stripe_invoice_id:  @invoice.values[1][0].id,
          invoice_currency: @invoice.values[1][0].lines.data[0].currency , 
          amount_paid: @invoice.values[1][0].lines.data[0].amount ,
          plan_id: @invoice.values[1][0].lines.data[0].plan.id,
          invoice_interval: @invoice.values[1][0].lines.data[0].plan.interval
        )

        redirect_to dash_admin_billing_path
     
      else
        @plan= Stripe::Plan.create({
          amount: month,
          interval: 'month',
          product: {
            name: 'Admin'+  +SecureRandom.hex(1)+  'User_Plan' +user.to_s ,
          },
          currency: 'eur',
          id: 'Admin'+  +SecureRandom.hex(1)+  'User_Plan' +user.to_s 
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

      @plans.build_subscription(stripe_subscription_id: @subscription.id , plan_id:  @plans.id ).save
       

      @invoice = Stripe::Invoice.list(limit: 3)
      @admin_invoice =Admin.where(stripe_id: @invoice.values[1][0].customer ).first
      @card=Card.where(stripe_custommer_id: @invoice.values[1][0].customer).first

      @admin_invoice.invoices.create(card_number:  @card.last_4_cards_digit ,
        stripe_invoice_id:  @invoice.values[1][0].id,
        invoice_currency: @invoice.values[1][0].lines.data[0].currency , 
        amount_paid: @invoice.values[1][0].lines.data[0].amount ,
        plan_id: @invoice.values[1][0].lines.data[0].plan.id,
        invoice_interval: @invoice.values[1][0].lines.data[0].plan.interval
      )

        redirect_to dash_admin_billing_path
      end
  end

  def set_admin
    @admin = current_admin
  end

end
