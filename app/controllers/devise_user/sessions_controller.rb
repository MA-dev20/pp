# frozen_string_literal: true

class DeviseUser::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
     super
  end

  # POST /resource/sign_in
  
  def create
    if !params[:admin][:email].nil? && !params[:admin][:password].nil?
      self.resource = warden.authenticate(auth_options)
      user = User.find_by_email(params[:admin][:email])
      if  !self.resource.nil?        
        if !((Date.today.to_s).eql?(self.resource.expiration.to_s))
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          return  render json: {response: "ok"} if request.xhr?
          respond_with resource, location: after_sign_in_path_for(resource)
        else
          redirect_to price_path
        end
      elsif user && user.encrypted_pw && (user.decrypt(user.encrypted_pw) == params[:admin][:password])
        set_flash_message!(:notice, :signed_in)
        sign_in(user)
        return  render json: {response: "ok", user: true} if request.xhr?

        return redirect_to dash_user_stats_url
      else  
        email = Admin.find_by_email(params[:admin][:email])
        errors = {}
        errors.merge!({email: true}) if !email.present?
        errors.merge!({password:  true}) if email.present? && !email.valid_password?(params[:admin][:password])
        if email.present?
          return render json: {response: "error", errors: errors}
        else
          if user 
            errors = {}
            errors.merge!({email: true}) if !user.present?
            errors.merge!({password:  true}) if user.present? && !(user.encrypt(params[:admin][:password]) == user.encrypted_pw)
            return render json: {response: "error", errors: errors}
          else
            return render json: {response: "error", errors: errors}
          end
        end
        redirect_to root_path
      end

    elsif !params[:admin][:email].nil? && params[:admin][:password].nil?
      @admin = Admin.where(email: params[:admin][:email]).first
      if @admin
        if @admin.verification_code_confirm == false
          respond_to do |format|
            format.js {render js: "window.location = '#{verification_token_path(@admin.vid_token)}'"}
            format.html{ redirect_to verification_token_path(@admin.vid_token)}
          end
        else
          respond_to do |format|
            format.html {redirect_to landing_index_path(login: true)}
            format.js {render js: "$('#exampleModalCenterLogin').modal('show')"}
          end
        end

      elsif !@admin
        email = params.dig(:admin, :email)
        @admin =Admin.where(email: email ).first_or_initialize
        @admin.password = "123456"
        @admin.token=  (SecureRandom.random_number(9e5) + 1e5).to_i
        @admin.vid_token= SecureRandom.hex(15)
        @admin.skip_confirmation!
        @admin.save
        AdminMailer.offer_to_mail(@admin).deliver  if
        
        respond_to do |format|
          format.js {render js: "window.location= '#{verification_token_path(@admin.vid_token)}'"}
          format.html{ redirect_to verification_token_path(@admin.vid_token)}
        end
        # redirect_to root_path , notice: 'Signup Information Sent to your Email Successfully.'
        puts "Offer sent."
        
      end

    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  protected
  def after_sign_in_path_for(resource)
    dash_admin_path
  end
end
