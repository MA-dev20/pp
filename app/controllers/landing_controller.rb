class LandingController < ApplicationController

  skip_before_action :check_expiration_date, only: :price

  layout 'main'
  respond_to :html, :json

  def index
  end
    
  def coach
  end
    
  def register
    @admin = Admin.new
  end

  def update_admin
    @admin = Admin.where(vid_token: params[:v_id]).first
      if @admin.update(admin_params)
        if @admin.password.eql?(@admin.password_confirm)
          # sign_in @admin
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
    def admin_params
      params.require(:admin).permit( :id, :company_name, :fname, :lname, :street,
        :city, :employees, :zipcode, :male ,:members ,:vid_token, :password , 
        :expiration ,:password_confirm)
    end
end
