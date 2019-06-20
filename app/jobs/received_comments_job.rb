class ReceivedCommentsJob < ApplicationJob
  queue_as :default

  def perform(user, turn)
    @user = user
    InvitationMailer.received_comments(@user, turn).deliver_later
  end
end