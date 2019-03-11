class CardsController < ApplicationController
   
    before_action :authenticate_admin!, :set_admin , unless: :skip_action?
    layout 'main'
    def create    
         puts"###################{@admin}#############" 
        # @=current_user
         @admin.card_id =params[:payment_gateway_token]
         @admin.save
    end


    def set_admin
      @admin = current_admin
     
    end

   def skip_action?
    (params[:token]) ? true : false  
   end
end
