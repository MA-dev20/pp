class AdminMailer < ApplicationMailer
   #default from: 'noreply@peterpitch.de'
  
    def offer_to_mail(admin)
        @admin = admin
        mail to: @admin.email , subject:"Token Verification Email"
    end
end
