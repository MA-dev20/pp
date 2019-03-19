class ApplicationController < ActionController::Base
  include DatabaseHelper
  include RootSessionHelper
    
  # before_action :authenticate
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_expiration_date

  def check_expiration_date
    if admin_signed_in?
       if current_admin.plans.blank? && Time.now >= current_admin.expiry
        redirect_to price_path
       end
    end
  end

  protected
    
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == 'PeterPitch' && password == 'PP_2019_CDJM'
      end
    end
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:male, :company_name, :fname, :lname, :street, :city, :employees, :zipcode])
      devise_parameter_sanitizer.permit(:account_update, keys: [:male, :company_name, :fname, :lname, :street, :city, :avatar, :logo, :employees, :zipcode])
    end

    def check_expiration_date
      if current_admin
         if current_admin.plans.blank && Time.now > current_admin.expiration 
          redirect_to price_path
         end
      end
    end

end
