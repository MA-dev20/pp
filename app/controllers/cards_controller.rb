class CardsController < ApplicationController
  before_action :authenticate_admin!, :set_admin , unless: :skip_action?
  layout 'main'
  respond_to :html, :json

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

  def update
    @card =Card.find(params[:id])
    respond_to do |format|
      Card.update_all(set_default_card: false)
        # if @card.update(cards_params)
        @card.update(set_default_card: true)
          format.html { redirect_to dash_admin_billing_path, :notice => 'Default Card Set' }
          format.json { respond_with_bip(@card) }
        # else
        #   flash[:alert]= @admin.errors.full_messages.to_sentence
        #   format.html { redirect_to dash_admin_billing_path  }
        #   format.json { respond_with_bip(@card) }
        # end
    end
  end

  def set_admin
    @admin = current_admin
  end

  def skip_action?
  (params[:token]) ? true : false  
  end

  private 
  def cards_params
    params.require(:card).permit( :set_default_card)
  end
end
