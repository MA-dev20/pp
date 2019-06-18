class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(user, pass)
    @user = user
    InvitationMailer.new_user(@user, pass).deliver_later
  end
end
