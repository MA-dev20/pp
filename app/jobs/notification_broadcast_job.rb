class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(game)
    ActionCable.server.broadcast "game_channel",
        game_state: game.state, game_admin_id: game.admin_id
  end
end
