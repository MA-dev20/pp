class BasketController < ApplicationController
  before_action :set_basket, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    rand_img = Random.new.rand(1..8)
    if(params[:basket][:type] == "objection")
        @basket = ObjectionsBasket.new(basket_params)
        (1..8).each do |i|
          if !current_admin.objection_baskets.select{|o| o.image === i}.present?
            rand_img = i
            break
          end
        end
        @basket.image = rand_img
    else
        @basket = CatchwordsBasket.new(basket_params)
        (1..8).each do |i|
          if !current_admin.catchword_baskets.where(objection: false).select{|c| c.image === i}.present?
            rand_img = i
            break
          end
        end
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
    elsif params[:basket][:site] == 'admin_dash'
        redirect_to dash_admin_catchwords_path(@basket.id)
    else
        redirect_to backoffice_words_path(@basket.id)
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
    else
        redirect_to backoffice_words_path(@basket.id)
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
        o.destroy
      end
    else
      @basket.words.each do |w|
        w.destroy
      end
    end
    if !@basket.destroy
      flash[:danger] = 'Konnte Liste NICHT löschen!'
    end
    if params[:site] == 'dash_admin'
      redirect_to  dash_admin_customize_path
    else
      redirect_to backoffice_baskets_path
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