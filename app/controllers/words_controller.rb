class WordsController < ApplicationController
  before_action :authenticate
  before_action :set_word, only: [:edit, :update, :destroy]
    
  #POST new_word 
  def create
    @basket = CatchwordsBasket.find_by(id: params[:basket_id])
    if params[:word][:sound]
        params[:word][:sound].each do |sound|
            @word = Word.find_by(name: sound.original_filename.split(".mp3").first)
            if @word
              if @word.update(sound: sound) && @basket.words.where(name: @word.name).count == 0
                @basket.words << @word
              else
                flash[:danger] = 'Konnte Wort nicht speichern'
              end
            else
              @word = @basket.words.create(sound: sound, name: sound.original_filename.split(".mp3").first)
              if !@word.save
                flash[:danger] = 'Konnte Wort nicht speichern!'
              end
            end
        end
    elsif params[:word][:name] && params[:word][:name] != ''
        @word = Word.find_by(name: params[:word][:name])
        if @word && @basket.words.where(name: @word.name).count == 0
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
    if !current_admin.nil?
      redirect_to dash_admin_catchwords_path(@basket.id)
    elsif @basket.admin
	  redirect_to backoffice_word_path(@basket.admin, @basket)
	else
      redirect_to backoffice_word_noadmin_path(@basket)
    end
  end
    
  #POST edit_word @basket, @word
  def update
    if !@word.update(word_params)
      flash[:danger] = 'Konnte Wort NICHT updaten!'
    end
	if @basket.admin
	  redirect_to backoffice_word_path(@basket.admin, @basket)
	else
      redirect_to backoffice_word_noadmin_path(@basket)
	end
  end
    
  #GET destroy_word @basket, @word
  def destroy
    if @word.catchword_baskets.count > 1
      @basket.words.delete(@word)
      flash[:success] = 'Wort aus Liste gelöscht!'
    elsif !@word.destroy
      flash[:danger] = 'Konnte Wort NICHT löschen!'
    end
    if !current_admin.nil?
        redirect_to dash_admin_catchwords_path(@basket.id)
	elsif @basket.admin
	  redirect_to backoffice_word_path(@basket.admin, @basket)
	else
      redirect_to backoffice_word_noadmin_path(@basket)
    end
  end
    
  private
    def authenticate
      if current_admin.nil? && current_root.nil?
          flash[:danger] = "Bitte logge dich ein!"
          redirect_to new_session_path(admin)
          return
      end
    end
    def set_word
      @word = Word.find(params[:word_id])
      @basket = CatchwordsBasket.find(params[:basket_id])
    end
    
    def word_params
      params.require(:word).permit(:name, :sound)
    end
end
