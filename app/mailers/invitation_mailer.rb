class InvitationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.before_start_game.subject
  #
  def before_start_game(user, game)
    @greeting = "Hi"
    @user = user
    @game = game
    mail to: @user.email
  end
end
