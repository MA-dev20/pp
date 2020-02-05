class InvitationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.before_start_game.subject
  #
  def before_start_game(user, game)
    @user = user
    @game = game
    mail to: @user.email, subject: 'Neues Spiel'
  end

  def new_user user, pass
    @user = user
	@password = pass
    mail to: @user.email, subject: 'Willkommen bei Peter Pitch'
  end

  def received_comments(user, turn)
    @user, @turn = user, turn
    mail to: @user.email, subject: 'Neue Kommentare'
  end
end


