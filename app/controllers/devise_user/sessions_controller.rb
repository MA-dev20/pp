# frozen_string_literal: true

class DeviseUser::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  
  def create
    if !params[:admin][:email].nil? && !params[:admin][:password].nil?
      self.resource = warden.authenticate(auth_options)
      if  !self.resource.nil?
        if !((Date.today.to_s).eql?(self.resource.expiration.to_s))
          set_flash_message!(:notice, :signed_in)
          sign_in(resource_name, resource)
          yield resource if block_given?
          respond_with resource, location: after_sign_in_path_for(resource) 

        else
          redirect_to price_path
        end
      
      else
        redirect_to landing_index_path
      #   email = params.dig(:admin, :email)
      #   # password = params.dig(:admin, :password)
      #   @admin =Admin.where(email: email ).first_or_initialize
      #   @admin.password = "123456"
      #   @admin.token=  (SecureRandom.random_number(9e5) + 1e5).to_i
      #   @admin.vid_token= SecureRandom.hex(15)
      #   @admin.skip_confirmation!
      #   @admin.save

      #   AdminMailer.offer_to_mail(@admin).deliver if 
      #   redirect_to verification_token_url(@admin.vid_token)
      #   # redirect_to root_path , notice: 'Signup Information Sent to your Email Successfully.'
      #   puts "Offer sent." 
      end

    elsif !params[:admin][:email].nil? && params[:admin][:password].nil?
      @admin = Admin.where(email: params[:admin][:email]).first
      if @admin
        redirect_to register_path

      elsif !@admin
        email = params.dig(:admin, :email)
        # password = params.dig(:admin, :password)
        @admin =Admin.where(email: email ).first_or_initialize
        @admin.password = "123456"
        @admin.token=  (SecureRandom.random_number(9e5) + 1e5).to_i
        @admin.vid_token= SecureRandom.hex(15)
        @admin.skip_confirmation!
        @admin.save

        AdminMailer.offer_to_mail(@admin).deliver if 
        redirect_to verification_token_url(@admin.vid_token)
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
