class UserMailer < ApplicationMailer
   default from: 'noreply@peterpitch.de'
  
    def after_activate(user, password)
	  @user = user
	  @password = password
	  mail to: @user.email, subject: "Du wurdest freigeschaltet!"
	end
	
	def new_password(user, password)
	  @user = user
	  @password = password
	  mail to: @user.email, subject: 'Neues Passwort!'
	end
	
	def new_comment(user, comment)
	  @user = user
	  @comment = comment
	  mail to: @user.email, subject: 'Neuer Kommentar!'
	end
	
	def new_video(user)
	  @user = user
	  mail to: @user.email, subject: 'Neues Video!'
	end
end