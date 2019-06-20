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

  def new_user user, pass
    @greeting = "HI #{user.fname}! Your password Is #{pass}"
    @user = user
    mail to: @user.email
  end

  def received_comments(user, turn)
    @user, @turn = user, turn
    @greeting = "HI #{user.fname}! You have received comments "
    mail to: @user.email
  end
end


