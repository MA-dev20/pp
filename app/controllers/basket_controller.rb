class BasketController < ApplicationController
  before_action :set_basket, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    rand_img = Random.new.rand(1..8)
    if(params[:basket][:type] == "objection")
        @basket = ObjectionsBasket.new(basket_params)
        @basket.image = rand_img
    else
        @basket = CatchwordsBasket.new(basket_params)
        @basket.image = rand_img
    end
    if params[:basket][:name] == ""
        if params[:basket][:type] == "objection"
        flash[:obasket_name] = 'Gib einen Namen an!'
        else
        flash[:basket_name] = 'Gib einen Namen an!'
        end
        if params[:basket][:site]
            redirect_to dash_admin_customize_path()
            return
        end
    elsif !@basket.save
      flash[:danger] = 'Konnte Liste nicht speichern!'
    end
    if params[:basket][:site] == 'admin_dash' && params[:basket][:type] == "objection"
        redirect_to dash_admin_objections_path(@basket.id)
        return
    elsif params[:basket][:site] == 'admin_dash'
        redirect_to dash_admin_catchwords_path(@basket.id)
        return
    elsif params[:basket][:site] == 'backoffice'
        redirect_to backoffice_edit_admin_path(params[:basket][:admin_id])
        return
    else
        redirect_to backoffice_words_path(@basket.id)
        return
    end
  end
    
  def edit
  end
    
  def update
    if params[:basket][:name] == ""
        flash[:basket_name] = 'Gib einen Namen an!'
    elsif !@basket.update(basket_params)
      flash[:danger] = 'Konnte Liste NICHT updaten!'
    end
    if (params[:basket][:site] == 'admin_dash' && params[:basket][:type] == "objection") || params[:basket][:site] == 'admin_dash'
        redirect_to dash_admin_customize_path
	elsif @basket.objection
		redirect_to backoffice_edit_objection_path(@basket.id)
	else
        redirect_to backoffice_edit_catchword_path(@basket.id)
    end
    # if params[:basket][:site] == 'admin_dash' && params[:basket][:type] == "objection"
    #     redirect_to dash_admin_objections_path(@basket.id)
    # elsif params[:basket][:site] == 'admin_dash'
    #     redirect_to dash_admin_customize_path
    # else
    #     redirect_to backoffice_words_path(@basket.id)
    # end
  end
    
  def destroy
    if @basket.objection
      @basket.objections.each do |o|
        if o.catchword_baskets.count == 1
          o.destroy
        else
          @basket.objections.delete(o)
        end
      end
    else
      @basket.words.each do |w|
        if w.catchword_baskets.count == 1
          w.destroy
        else
          @basket.words.delete(w)
        end
      end
    end
    if !@basket.destroy
      flash[:danger] = 'Konnte Liste NICHT löschen!'
    end
    if !current_root.nil? && @basket.admin
      redirect_to backoffice_edit_admin_path(@basket.admin)
	elsif !current_root.nil?
      redirect_to backoffice_word_baskets_path
    else
      redirect_to  dash_admin_customize_path
    end
  end
    
  private
    def set_basket
      @basket = CatchwordsBasket.find(params[:basket_id])
    end
    
    def basket_params
      params.require(:basket).permit(:name, :admin_id)
    end
end