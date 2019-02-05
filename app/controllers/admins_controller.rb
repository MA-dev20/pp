class AdminsController < ApplicationController
  before_action :set_admin, only: [:update, :destroy]
    
  def new
  end
    
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      flash[:info] = 'Willkommen bei PeterPitch'
      admin_login @admin
      redirect_to dash_admin_path
    else
      flash[:danger] = 'Konnte Admin nicht erstellen!'
      redirect_to register_path
    end
  end
    
  def edit
  end
    
  def update
    if @admin.update(admin_params)
      flash[:info] = 'Daten erfolgreich geupdated!'
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Daten NICHT geupdated!'
      redirect_to dash_admin_account_path
    end
  end
    
  def destroy
    if @admin.destroy
      admin_logout
      flash[:success] = 'User erfolgreich gelöscht!'
      redirect_to root_path
    else
      flash[:danger] = 'User NICHT gelöscht'
      redirect_to dash_admin_path
    end
  end
    
  private
    def admin_params
      params.require(:admin).permit(:male, :company_name, :email, :password, :fname, :lname, :street, :city, :avatar, :logo, :employees, :zipcode)
    end
    def set_admin
      @admin = Admin.find(params[:admin_id])
    end
end