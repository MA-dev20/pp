class VerificationController < ApplicationController
  layout 'main'

  def token
      @admin =Admin.where(vid_token: params[:token]).first
  end

  def verify_token
    @admin =Admin.where(token: params[:token]).first
    if @admin
      redirect_to edit_admin_path(v_id: @admin.vid_token)
    else
      redirect_to verification_token_url(params[:vid_token])
      # flash[:notice]= "Enter Wrong Verification token "
    end
  end


end
