class ObjectionsController < ApplicationController
    before_action :set_basket
    
    def new
    end
    
    def create
      if params[:objection][:name] != ""
          @objection = Objection.new(objection_params)
          if @objection.save
            @basket.objections << @objection
          end
      else
        flash[:objection_name] = 'Gib einen Namen an!'
      end
      if params[:objection][:site] == 'admin_dash'
        redirect_to dash_admin_objections_path(@basket)
      end
    end
    
    def destroy
      @objection =  Objection.find(params[:objection_id])
      if @objection.destroy
        redirect_to dash_admin_objections_path(@basket.id)
      else
        flash[:danger] = 'Konnte Objection NICHT löschen!'
        redirect_to dash_admin_objections_path(@basket.id)
      end
    end
    private
      def objection_params
        params.require(:objection).permit(:name, :sound)
      end
      def set_basket
        @basket = ObjectionsBasket.find(params[:basket_id])
      end
end