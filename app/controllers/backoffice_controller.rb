class BackofficeController < ApplicationController
  before_action :if_root
  before_action :require_root, :set_root
  before_action :set_admin, only: [:admin, :activate_admin, :destroy_admin, :edit_admin]
  before_action :if_basket, only: [:word_baskets]
  before_action :set_basket, only: [:words]
  layout 'backoffice'
      
  #GET backoffice_admins
  def index
    @admins = Admin.all
  end

  def admins
    @admins = Admin.all
  end
    
  def admin
    @users = @admin.users.all
    @cw_baskets = @admin.catchword_baskets.where(objection: false)
    @ob_baskets = @admin.objection_baskets.all
  end
    
  def edit_admin
  end
    
  def edit_team
    @team = Team.find(params[:team_id])
    @admin = @team.admin
  end

  def edit_user
    @user = User.find(params[:user_id])
    @admin =  @user.admin
  end
    
  def edit_catchword
    @basket = CatchwordsBasket.find(params[:basket_id])
	@words = @basket.words.order("name")
    if params[:admin]
      @admin = Admin.find(params[:admin])
    end
  end

  def edit_objection
    @basket = ObjectionsBasket.find(params[:basket_id])
	@objections = @basket.objections.order('name')
    if params[:admin]
      @admin = Admin.find(params[:admin])
    end
  end
    
  def activate_admin
	password = SecureRandom.urlsafe_base64(8)
	@admin.password = password
    if @admin.update(activated: true)
      flash[:success] = 'Admin aktiviert'
	  AdminMailer.after_activate(@admin, password).deliver
    else
      flash[:danger] = 'FEHLER!'
    end
    redirect_to backoffice_admin_path(@admin)
  end
  def destroy_admin
    if @admin.destroy
      flash[:success] = 'Admin deactiviert'
      redirect_to backoffice_path
    else
      flash[:danger] = 'FEHLER!'
      redirect_to backoffice_admin_path(@admin)
    end
  end
    
  #GET backoffice_words
  def word_baskets
    @baskets = CatchwordsBasket.where(admin_id: nil)
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
    def set_admin
      @admin = Admin.find(params[:admin_id])
    end
    def set_basket
      @basket = CatchwordsBasket.find(params[:basket_id])
    end
      
    def if_basket
      if CatchwordsBasket.where(name: 'PetersWords').count == 0
        CatchwordsBasket.create(name: 'PetersWords')
      end
	  if ObjectionsBasket.where(name: 'PetersObjections').count == 0
        ObjectionsBasket.create(name: 'PetersObjections')
      end
    end

    def admin_params
      params.require(:admin).permit(:fname, :lname, :company_name, :email, :password, :password_confirm)
    end
end
