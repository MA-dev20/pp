class AdminsDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  layout 'devise_mailer' # to make sure that your mailer uses the devise view

  # Overrides same inside Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def headers_for(action, opts)
    super.merge!({template_path: '/admins/mailer'}) # this moves the Devise template path from /views/devise/mailer to /views/mailer/devise
	end

  # Overrides same inside Devise::Mailer
  
end