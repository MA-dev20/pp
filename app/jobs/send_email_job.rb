class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(user, game)
    @user = user
    InvitationMailer.before_start_game(@user, game).deliver_later
  end
end
