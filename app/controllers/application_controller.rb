class ApplicationController < ActionController::Base
  include DatabaseHelper
  include AdminSessionHelper
  include GameSessionHelper
  include RootSessionHelper
    
  before_action :authenticate
    
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == 'PeterPitch' && password == 'PaS_AHB-2023?'
    end
  end
end
