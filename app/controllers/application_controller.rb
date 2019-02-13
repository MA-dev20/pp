class ApplicationController < ActionController::Base
  include DatabaseHelper
  include GameSessionHelper
  include RootSessionHelper
    
  before_action :authenticate
  before_action :configure_permitted_parameters, if: :devise_controller?
    
  protected
    
    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == 'PeterPitch' && password == 'PP_2019_123'
      end
    end
    
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:company_name, :fname, :lname, :street, :city, :employees, :zipcode])
      devise_parameter_sanitizer.permit(:account_update, keys: [:company_name, :fname, :lname, :street, :city, :avatar, :logo, :employees, :zipcode])
    end
end
