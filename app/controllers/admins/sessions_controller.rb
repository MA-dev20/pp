class Admins::SessionsController < Devise::SessionsController
  protected
    def after_sign_in_path_for(resource)
      dash_admin_path
    end
end