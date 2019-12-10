class ObjectionsController < ApplicationController
    before_action :set_basket
    before_action :set_objection, only: [:update, :destroy]
    
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
      if !current_root.nil?
        redirect_to backoffice_edit_objection_path(@basket)
      else
        redirect_to dash_admin_objections_path(@basket)
      end
    end
    
    def update
      if !@objection.update(objection_params)
        flash[:danger] = "Fehler!"
      end
      if !current_root.nil?
        redirect_to backoffice_edit_objection_path(@basket)
      else
        redirect_to dash_admin_objections_path(@basket)
      end
    end
    
    def destroy
      if !@objection.destroy
        flash[:danger] = 'Konnte Objection NICHT löschen!'
      end
      if !current_root.nil?
        redirect_to backoffice_edit_objection_path(@basket)
        return
      else
        redirect_to dash_admin_objections_path(@basket.id)
        return
      end
    end
    private
      def objection_params
        params.require(:objection).permit(:name, :sound)
      end
      def set_basket
        @basket = ObjectionsBasket.find(params[:basket_id])
      end
      def set_objection
        @objection =  Objection.find(params[:objection_id])
      end
end