class LandingController < ApplicationController
  layout 'main'
  def index
  end
    
  def coach
  end
    
  def register
    @admin = Admin.new
  end

  def update_admin
    @admin = Admin.where(vid_token: :vid_token).first
    respond_to do |format|
      if @admin.update_attributes(admin_params)
        format.html { redirect_to root_path, :notice => 'updated.' }
        format.json { respond_with_bip(@admin) }
      else
        flash[:alert]= @admin.errors.full_messages.to_sentence
        format.html { redirect_to  root_path  }
        format.json { respond_with_bip(@admin) }
    
      end
    end
  end
  def sign_up
    @admin = Admin.where(vid_token: params[:v_id]).first

  end

  private 
    def admin_params
      params.require(:admin).permit( :id, :company_name, :fname, :lname, :street,
         :city, :employees, :zipcode, :male ,:members ,:vid_token)
    end
end
