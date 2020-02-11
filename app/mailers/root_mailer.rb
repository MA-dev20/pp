class RootMailer < ApplicationMailer
   #default from: 'noreply@peterpitch.de'
  
    def after_create(root, password)
        @root = root
		@password = password
        mail to: @root.email , subject:"Dein Passwort"
    end
	
	def after_admin_creation(admin)
	  @admin = admin
	  mail to: 'info@peterpitch.com', subject: 'Neuer Admin'
	end
end
