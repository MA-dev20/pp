class BackofficeController < ApplicationController
  before_action :if_root
  before_action :require_root, :set_root
  layout 'backoffice'
    
  def index
  end
    
  #GET backoffice_admins
  def admins
    @admins = Admin.all
  end
    
  def baskets
    if params[:admin_id]
      @admin = Admin.find(params[:admin_id])
      @baskets = @admin.catchword_baskets
    elsif CatchwordsBasket.find_by(name: 'PetersWords').nil?
      @basket = CatchwordsBasket.create(name: 'PetersWords')
      @basket1 = CatchwordsBasket.create(name: 'PetersFreeWords')
      @baskets = CatchwordsBasket.where(admin_id: nil).all
    else
      @baskets = CatchwordsBasket.where(admin_id: nil).all
    end
  end
  #GET backoffice_words
  def words
    @basket = CatchwordsBasket.find(params[:basket_id])
    @words = @basket.words.all
  end
    
  private
    def if_root
      if Root.count == 0
        Root.create(username: 'root', password: 'ratte')
      end
    end
    def set_root
      @root = current_root
    end
end
