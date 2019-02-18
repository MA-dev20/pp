class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(game)
    ActionCable.server.broadcast "game_channel",
                                 game_state: '<p>testing</p>', url: 'wwww.google.com'
  end
end
