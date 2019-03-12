class CardsController < ApplicationController
    before_action :authenticate_admin!, :set_admin , unless: :skip_action?
    layout 'main'


    def create  
        
      # if !@admin.cards.exists?
      # @admin.cards.create(admin_id: @admin.id, card_token_id: params[:payment_gateway_token], set_default_card: true)
      # redirect_to dash_admin_path
      # else
      # @admin.cards.create(admin_id: @admin.id, card_token_id: params[:payment_gateway_token], set_default_card: false)
      # redirect_to dash_admin_path
      # end
      @card =  Stripe::Customer.create_source(@admin.stripe_id,
        {  source: params[:payment_gateway_token] }
        )      
        @admin.cards.create(admin_id: @admin.id, set_default_card: true,
          stripe_card_id: @card.id,last_4_cards_digit: @card.last4  ,expiry_month: @card.exp_month,
          expiry_year: @card.exp_year,card_brand: @card.brand )
        redirect_to dash_admin_path
    end


    def set_admin
      @admin = current_admin
    end

   def skip_action?
    (params[:token]) ? true : false  
   end
end
