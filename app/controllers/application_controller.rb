class ApplicationController < ActionController::Base
  include DatabaseHelper
  include RootSessionHelper
  include ApplicationHelper
    
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_expiration_date
#  before_action :authenticate_request
  
  def check_expiration_date
    if admin_signed_in?
      if current_admin.plan_id.blank? && Time.now >= current_admin.expiry
        if current_admin.cards.blank?
          flash[:danger] = "Please add card details to continue using application"
          return redirect_to dash_admin_billing_path 
        else
          flash[:danger] = "Please Select Plan type"
          return redirect_to price_path
        end
      end
    end
  end
  
  protected
    
    def authenticate_request
      authenticate_or_request_with_http_basic do |username, password|
        username == 'PeterPitch' && password == 'PP_2019_CDJM'
      end
    end
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:male, :company_name, :fname, :lname, :street, :city, :employees, :zipcode, :teams])
      devise_parameter_sanitizer.permit(:account_update, keys: [:male, :company_name, :fname, :lname, :street, :city, :avatar, :logo, :employees, :zipcode, :teams])
    end
end
