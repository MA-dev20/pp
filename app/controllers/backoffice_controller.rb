class BackofficeController < ApplicationController
  before_action :require_root, :set_root
  layout 'backoffice'
    
  def index
  end
    
  #GET backoffice_admins
  def admins
    @admins = Admin.all
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
