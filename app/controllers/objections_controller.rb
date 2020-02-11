class ObjectionsController < ApplicationController
    before_action :set_basket
    before_action :set_objection, only: [:update, :destroy]

	#POST new_objection @basket
    def create
	  if params[:objection][:sound]
	    params[:objection][:sound].each do |sound|
		  @objection = Objection.find_by(name: sound.original_filename.split('.mp3').first)
		  if @objection
			@objection.update(sound: sound)
		    @basket.objections << @objection
		  elsif	!@basket.objections.create(sound: sound, name: sound.original_filename.split('.mp3').first)
			flash[:danger] = 'Konnte Einwand nicht speichern!'
		  end
		end
	  elsif params[:objection][:name] && params[:objection][:name] != ''
		@objection = Objection.find_by(name: params[:objection][:name])
		if @objection && @basket.words.where(name: @objection.name).count == 0
		  @basket.objections << @objection
		else
		  if !@basket.objections.create(name: params[:objection][:name])
		    flash[:danger] = 'Konnte Einwand nicht speichern!'
		  end
		end
	  else
		flash[:danger] = 'Gib einen Namen an!'
	  end
	  if !current_admin.nil?
		redirect_to dash_admin_objections_path(@basket.id)
	  elsif @basket.admin
		redirect_to backoffice_objection_path(@basket.admin, @basket)
	  else
		redirect_to backoffice_objection_noadmin_path(@basket)
	  end
    end
    
	#POST edit_objection @basket, @objection
    def update
      if !@objection.update(objection_params)
        flash[:danger] = "Konnte Objection NICHT updaten!"
      end
	  if !current_admin.nil?
		redirect_to dash_admin_objections_path(@basket)
	  elsif @basket.admin
		redirect_to backoffice_objection_path(@basket.admin, @basket)
	  else
		redirect_to backoffice_objection_noadmin_path(@basket)
      end
    end
    
	#GET destroy_objection @basket, @objection
    def destroy
	  if @objection.catchword_baskets.count > 1
		@basket.objections.delete(@objection)
	  elsif !@objection.destroy
        flash[:danger] = 'Konnte Objection NICHT löschen!'
      end
      if !current_admin.nil?
        redirect_to dash_admin_objections_path(@basket.id)
	  elsif @basket.admin
		redirect_to backoffice_objection_path(@basket.admin, @basket)
	  else
		redirect_to backoffice_objection_noadmin_path(@basket)
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