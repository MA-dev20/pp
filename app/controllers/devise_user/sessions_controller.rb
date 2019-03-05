# frozen_string_literal: true

class DeviseUser::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  
  def create
    
    self.resource = warden.authenticate(auth_options)
    if  !self.resource.nil?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource) 
    else
      # self.resource.token= rand(10 ** 6).to_s.rjust(6,'0') 
      # puts self.token
      email = params.dig(:admin, :email)
      password = params.dig(:admin, :password)

      @admin =Admin.where(email: email ).first_or_initialize
      @admin.password = password
      @admin.token= rand(10 ** 6).to_s.rjust(6,'0')
      @admin.vid_token= SecureRandom.hex[0..7]

      @admin.save

      AdminMailer.offer_to_mail(@admin).deliver if email
            
      redirect_to root_path , notice: 'Signup Information Sent to your Email Successfully.'
      puts "Offer sent."
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
end
