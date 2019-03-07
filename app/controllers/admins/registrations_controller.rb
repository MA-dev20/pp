class Admins::RegistrationsController < Devise::RegistrationsController
  
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
end