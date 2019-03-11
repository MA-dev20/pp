class CardsController < ApplicationController
   
    before_action :authenticate_admin!, :set_admin , unless: :skip_action?
    layout 'main'
    def create    
         puts"###################{@admin}#############" 
         @admin.cards.create(admin_id: @admin.id, card_token_id: params[:payment_gateway_token])
         redirect_to root_path
    end


    def set_admin
      @admin = current_admin
    end

   def skip_action?
    (params[:token]) ? true : false  
   end
end
