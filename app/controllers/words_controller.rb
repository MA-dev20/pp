class WordsController < ApplicationController
  before_action :set_word, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    @word = Word.create(word_params)
    @word.name = @word.sound_identifier.remove('.mp3')
    @word.free = false
    if @word.save
      flash[:success] = 'Wort gespeichert!'
      redirect_to backoffice_words_path
    else
      flash[:danger] = 'Konnte Wort nicht speichern!'
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
    if @word.destroy
      flash[:success] = 'Wort gelöscht!'
      redirect_to backoffice_words_path
    else
      flash[:danger] = 'Konnte Wort NICHT löschen!'
      redirect_to backoffice_words_path
    end
  end
    
  private
    def set_word
      @word = Word.find(params[:word_id])
    end
    
    def word_params
      params.require(:word).permit(:name, :sound, :free)
    end
end
