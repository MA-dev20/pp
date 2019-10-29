class WordsController < ApplicationController
  before_action :set_word, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    @basket = CatchwordsBasket.find_by(id: params[:basket_id])
    if params[:word][:sound]
        params[:word][:sounds].each do |sound|
            @word = @basket.words.create(sound: sound)
            @word.name = @word.sound_identifier.remove('.mp3')
            if !@word.save
              flash[:danger] = 'Konnte Wort nicht speichern!'
            end
        end
    elsif params[:word][:name] && params[:word][:name] != ''
        @word = Word.find_by(name: params[:word][:name])
        if @word
          @basket.words << @word
        else
          @word = Word.new(name: params[:word][:name])
          if @word.save
            @basket.words << @word
          end
        end
    else
        flash[:word_name] = 'Gib einen Namen an!'
    end
    if params[:word][:site] == 'admin_dash'
      redirect_to dash_admin_catchwords_path(@basket.id)
    else
      redirect_to backoffice_words_path
    end
  end
    
  def edit
  end
    
  def update
    if @word.update(word_params)
      flash[:success] = 'Wort geupdated!'
      redirect_to backoffice_words_path
    else
      flash[:danger] = 'Konnte Wort NICHT updaten!'
      redirect_to backoffice_words_path
    end
  end
    
  def destroy
    if @word.catchword_baskets.count > 1
      @basket.words.delete(@word)
      flash[:success] = 'Wort aus Liste gelöscht!'
      redirect_to dash_admin_catchwords_path(@basket.id)
    elsif @word.destroy
      flash[:success] = 'Wort gelöscht!'
      redirect_to dash_admin_catchwords_path(@basket.id)
    else
      flash[:danger] = 'Konnte Wort NICHT löschen!'
      redirect_to dash_admin_catchwords_path(@basket.id)
    end
  end
    
  private
    def set_word
      @word = Word.find(params[:word_id])
      @basket = CatchwordsBasket.find(params[:basket_id])
    end
    
    def word_params
      params.require(:word).permit(:name, :sound)
    end
end
