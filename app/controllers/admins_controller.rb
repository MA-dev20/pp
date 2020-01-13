class AdminsController < ApplicationController

  before_action :set_admin, :authenticate, except: [:new, :create]
  before_action :authenticate_root, only: [:activate]
   
  def create
    @admin = Admin.find_by(email: admin_params[:email])
    if @admin
      flash[:admin_email] = 'Email schon vergeben!'
	  if !current_root.nil?
		redirect_to backoffice_admin_path(@admin)
	  else
		redirect_to contact_path
	  end
    else
      @admin = Admin.new(admin_params)
	  password = SecureRandom.urlsafe_base64(8)
	  @admin.password = password
      if !current_root.nil?
        @admin.activated = true
      else
        @admin.activated = false
      end
      @admin.skip_password_validation = true
      if !@admin.save
        flash[:admin_error] = 'Konnte Anfrage nicht bearbeiten!'
      end
      if !current_root.nil?
		AdminMailer.after_activate(@admin, password).deliver
        redirect_to backoffice_admin_path(@admin)
      else
        flash[:thanks_for_register] = 'Wir haben deine Nachricht erhalten! Einer unserer Wölfe wird sich zeitnah mir Dir in Verbindung setzen.'
        redirect_to root_path
      end
    end
  end
  
  def update
    if !@admin.update(admin_params)
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
    if !current_root.nil?
      redirect_to backoffice_edit_admin_path(@admin)
    else
      redirect_to dash_admin_account_path
    end
  end

  def destroy
    @name = @admin.fname
    if !@admin.destroy
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      if !current_root.nil?
        redirect_to backoffice_admins_path
        return
      else
        redirect_to dash_admin_path
        return
      end
    else
      if !current_root.nil?
        flash[:success] = 'Admin erfolgreich gelöscht'
        redirect_to backoffice_admins_path
        return
      else
        sign_out @admin
        redirect_to byebye_path(name: @name)
        return
      end
    end
  end
    
  def activate
    if @admin.update(activated: true)
      flash[:success] = 'Admin aktiviert'
      @admin.send_reset_password_instructions
    else
      flash[:danger] = 'Konnte Admin nicht aktivieren!'
    end
    redirect_to backoffice_admin_path(@admin)
  end

  def update_logo
    if @admin.update(logo: params[:file])
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
  end
    
  def update_avatar
    if @admin.update(avatar: params[:file])
      redirect_to dash_admin_account_path
    else
      flash[:danger] = 'Konnte Admin nicht speichern!'
    end
  end

  private
    def authenticate
      if current_admin.nil? && current_root.nil?
        flash[:danger] = 'Bitte logge dich ein!'
        redirect_to root_path
      end
    end
    
    def authenticate_root
      if current_root.nil?
        flash[:danger] = 'Bitte logge dich ein!'
        redirect_to root_path
      end
    end
    
    def set_admin
      @admin = Admin.find(params[:admin_id])
    end
    
    def admin_params
      params.require(:admin).permit(:fname, :lname, :company_name, :employees, :company_position, :telephone, :message, :street, :city, :avatar, :logo, :zipcode, :email, :password)
    end
end