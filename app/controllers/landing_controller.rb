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
    
  def register
    @admin = Admin.new
  end
    
  def after_register
  end
    
  def byebye
  end

  def update_admin
    @admin = Admin.where(vid_token: params[:v_id]).first
      if @admin.update(admin_params)
        if @admin.password.eql?(@admin.password_confirm)
          # sign_in @admin
          @admin.update(verification_code_confirm: true)
          redirect_to edit_next_admin_path( @admin.vid_token)
        else
          flash[:notice] = "Password Doesnot match"
          redirect_to edit_admin_path
        end
      else
        flash[:alert]= @admin.errors.full_messages.to_sentence
        redirect_to  edit_admin_path  
      end
  end
  
  def update_admin_details
    @admin = Admin.where(vid_token: params[:v_id]).first

      if @admin.update(admin_params)
          sign_in @admin
          redirect_to dash_admin_path
      else
        flash[:alert]= @admin.errors.full_messages.to_sentence
        redirect_to  edit_admin_path  
      end
  end

  def sign_up
    @admin = Admin.where(vid_token: params[:v_id]).first
  end
  
  def signup
    @admin = Admin.where(vid_token: params[:v_id]).first
  end
  def price
  end

  def product
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
