class ApplicationController < ActionController::Base
  include DatabaseHelper
  include AdminSessionHelper
  include GameSessionHelper
  include RootSessionHelper
    
  before_action :authenticate
    
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'PeterPitch' && password == 'PP_2019_123'
    end
  end
end
