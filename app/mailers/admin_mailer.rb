class AdminMailer < ApplicationMailer
   #default from: 'noreply@peterpitch.de'
  
    def offer_to_mail(admin)
        @admin = admin
        mail to: @admin.email , subject:"Token Verification Email"
    end
	
	def after_activate(admin, password)
	  @admin = admin
	  @password = password
	  mail to: @admin.email, subject: "Du wurdest freigeschaltet!"
	end
end
