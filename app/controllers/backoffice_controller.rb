class BackofficeController < ApplicationController
  before_action :require_root, :set_root
  layout 'backoffice'
    
  def index
  end
    
  #GET backoffice_coaches
  def coaches
    @coaches = Admin.where(coach: true)
  end
    
  #GET backoffice_companies
  def companies
    @companies = Admin.where(coach: false)
  end
    
  #GET backoffice_words
  def words
    @words = Word.all
  end
    
  private
    def set_root
      @root = current_root
    end
end
