class CardsController < ApplicationController
    before_action :authenticate_admin!, :set_admin , unless: :skip_action?
    layout 'main'


    def create  
      if !@admin.cards.exists?
        @card =  Stripe::Customer.create_source(@admin.stripe_id,
          {  source: params[:payment_gateway_token] }
          )      
          @admin.cards.create(admin_id: @admin.id, set_default_card: true,
            stripe_card_id: @card.id,last_4_cards_digit: @card.last4  ,expiry_month: @card.exp_month,
            expiry_year: @card.exp_year,card_brand: @card.brand )
          redirect_to dash_admin_billing_path
      else
        @card =  Stripe::Customer.create_source(@admin.stripe_id,
          {  source: params[:payment_gateway_token] }
          )      
          @admin.cards.create(admin_id: @admin.id, set_default_card: false,
            stripe_card_id: @card.id,last_4_cards_digit: @card.last4  ,expiry_month: @card.exp_month,
            expiry_year: @card.exp_year,card_brand: @card.brand )
          redirect_to dash_admin_billing_path
      end
    end


    def set_admin
      @admin = current_admin
    end

   def skip_action?
    (params[:token]) ? true : false  
   end
end
