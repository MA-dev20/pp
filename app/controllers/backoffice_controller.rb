class BackofficeController < ApplicationController
  before_action :if_root
  before_action :require_root, :set_root
  layout 'backoffice'
  
  def new
    @admin1 = Admin.new
  end

  def create
    @admin1 = Admin.new(admin_params)
    if @admin1.password.eql?(@admin1.password_confirm)
      if @admin1.save
        flash[:notice] = "Admin created"
        redirect_to backoffice_admins_path
      else
        flash[:alert]= @admin1.errors.full_messages.to_sentence
        render 'new'  
      end
    else
      flash[:notice] = "Password Doesnot match"
      render 'new'
    end
  end

  def edit
    @admin1 = Admin.find(params[:id])
  end

  def update
    @admin1 = Admin.find(params[:id])
    if @admin1.update(admin_params)
      if @admin1.password.eql?(@admin1.password_confirm)
        flash[:notice] = "Admin record updated"
        redirect_to backoffice_admins_path
      else
        flash[:notice] = "Password Does not match"
        render 'edit'
      end
    else
      flash[:alert]= @admin1.errors.full_messages.to_sentence
      render 'edit' 
    end
  end

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

    def admin_params
      params.require(:admin).permit(:fname, :lname, :company_name, :email, :password, :password_confirm)
    end
end
