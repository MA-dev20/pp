class LandingController < ApplicationController
  layout 'main'
  def index
  end
    
  def coach
  end
    
  def register
    @admin = Admin.new
  end

end
