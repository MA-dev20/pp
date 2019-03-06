class VerificationController < ApplicationController

    def token
        debugger
        @admin =Admin.where(vid_token: params[:token]).first
    end


    def verify_token
        debugger
        @admin =Admin.where(token: params[:token]).first
        if @admin
            debugger
            redirect_to edit_admin_path(v_id: @admin.vid_token)
        else
            redirect_to verification_token_url(@admin.vid_token)
        end

    end


end
