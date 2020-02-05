class SendInvitationJob < ApplicationJob
  queue_as :default

  def perform(user, team)
    @user = user
	@team = team
    InvitationMailer.new_user(@user, @team).deliver_later
  end
end
