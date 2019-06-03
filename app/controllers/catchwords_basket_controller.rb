class CatchwordsBasketController < ApplicationController
  before_action :set_basket, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    @basket = CatchwordsBasket.new(basket_params)
    if @basket.save
      flash[:success] = 'Wort gespeichert!'
    else
      flash[:danger] = 'Konnte Wort nicht speichern!'
    end
    redirect_to backoffice_words_path(@basket.id)
#    @word = Word.create(word_params)
#    @word.name = @word.sound_identifier.remove('.mp3')
#    @word.free = false
#    if @word.save
#      flash[:success] = 'Wort gespeichert!'
#      redirect_to backoffice_words_path
#    else
#      flash[:danger] = 'Konnte Wort nicht speichern!'
#      redirect_to backoffice_words_path
#    end
  end
    
  def edit
  end
    
  def update
    if @basket.update(basket_params)
      flash[:success] = 'Liste geupdated!'
      redirect_to backoffice_words_path(@basket.id)
    else
      flash[:danger] = 'Konnte Liste NICHT updaten!'
      redirect_to backoffice_words_path(@basket.id)
    end
  end
    
  def destroy
    @basket.words.each do |w|
        w.destroy
    end
    if @basket.destroy
      flash[:success] = 'Liste gelöscht!'
      redirect_to backoffice_baskets_path
    else
      flash[:danger] = 'Konnte Liste NICHT löschen!'
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