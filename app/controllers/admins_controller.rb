class AdminsController < ApplicationController

  before_action :set_admin, except: [:new, :create]
  before_action :require_root, :set_vars

  def new
  end
    
  def create
    @admin = Admin.find_by(email: admin_params[:email])
    if @admin
      flash[:admin_email] = 'Email schon vergeben!'
    else
      @admin = Admin.new(admin_params)
      @admin.activated = false
      @admin.skip_password_validation = true
      if @admin.save
        redirect_to after_register_path(@admin)
      else
        flash[:admin_error] = 'Konnte Anfrage nicht bearbeiten!'
      end
    end
  end

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
      params.require(:admin).permit(:fname, :lname, :company_name, :employees, :company_position, :telephone, :message, :street, :city, :avatar, :logo, :zipcode, :email, :password)
    end
end
