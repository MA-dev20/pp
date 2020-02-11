class Admins::RegistrationsController < Devise::RegistrationsController
  def create
    @admin = Admin.new(admin_params)
    @admin.activated = false
    @admin.skip_password_validation = true
    if !@admin.save
      redirect_to contact_path
    else
	  RootMailer.after_admin_creation(@admin).deliver
      redirect_to after_register_path(@admin)
    end
  end
  def update
	if admin_params[:password] != admin_params[:password_confirmation]
		flash[:password_length] = "stimmen nicht überein"
		redirect_to dash_admin_account_path
	else
	resource.skip_password_validation = true
	resource.skip_reconfirmation!
	resource.update(admin_params)
	if admin_params[:password].length > 0 && admin_params[:password].length < 6
	  flash[:password_length] = "min. 6 Zeichen"
	end
	bypass_sign_in resource
	redirect_to dash_admin_account_path
	end
  end
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to byebye_path(name: resource.fname) }
  end
  protected
    def after_sign_up_path_for(resource)
      dash_admin_path
    end
    
    def after_update_path_for(resource)
      dash_admin_account_path
    end
    
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  private
    def admin_params
      params.require(:admin).permit(:fname, :lname, :company_name, :employees, :company_position, :telephone, :message, :street, :city, :avatar, :logo, :zipcode, :email, :password, :password_confirmation)
    end
end