class AdminsController < ApplicationController

  before_action :set_admin
    
  def edit
  end
    
  def update
    if @admin.update(admin_params)
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
  end
    
  def destroy
    if @admin.destroy
      flash[:success] = 'Spieler erfolgreich gelöscht!'
      redirect_to backoffice_admins_path
    else
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      redirect_to backoffice_admins_path
    end
  end
    
  def edit_logo
  end
    
  def update_logo
    if @admin.update(logo: params[:file])
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
  end
    
  def edit_avatar
  end
    
  def update_avatar
    if @admin.update(avatar: params[:file])
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
  end





    
  private
    def set_admin
      @admin = Admin.find(params[:admin_id])
    end
    
    def admin_params
      params.require(:admin).permit(:company_name, :fname, :lname, :street, :city, :avatar, :logo, :zipcode, :email, :password)
    end
end
