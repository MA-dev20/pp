class AdminChannel < ApplicationCable::Channel
  def subscribed
  	stream_from "admin_#{params['admin_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
