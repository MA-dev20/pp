class GamesChannel < ApplicationCable::Channel
  def subscribed
    stream_for "game_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    # process data sent from the page
  end
end