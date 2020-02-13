class LandingController < ApplicationController

  # skip_before_action :check_expiration_date, only: :price
  before_action :check_sessions, only: [:index,:price, :product]

  layout 'main'
  respond_to :html, :json

  def after_confirm
	@admin = Admin.find(params[:admin_id])
  end
  def accept_cookies
	cookies[:accepted] = 'true'
	redirect_to root_path
  end

  def datenschutz
  end
  def impressum
  end
	
  def index
  end

  def blog
	@blogs = Blog.all
	@blog = @blogs.count == 0 ? nil : @blogs.last
  end
  def show_blog
	@blog = Blog.find(params[:blog_id])
	@blogs = Blog.where.not(id: @blog.id).last(3)
  end
  def ended_game
	if !current_admin.nil?
	  sign_out(current_admin)
	end
	if !current_game.nil?
	  sign_out(current_game)
	end
	if !current_user.nil?
      sign_out(current_user)
	end
  end
    
  def contact
  end
    
  def byebye
  end

  private 
    def check_sessions   
      return redirect_to dash_admin_path if current_admin.present?   
      return redirect_to dash_user_stats_path if current_user.present?   
    end

    def admin_params
      params.require(:admin).permit( :id, :company_name, :fname, :lname, :street,
        :city, :employees, :zipcode, :male ,:members ,:vid_token, :password , 
        :expiration ,:password_confirm)
    end
end
