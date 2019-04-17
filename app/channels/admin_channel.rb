class AdminChannel < ApplicationCable::Channel
  def subscribed
  	stop_all_streams
  	stream_from "admin_#{params['admin_id']}_channel"
  end

  def unsubscribed
  	stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end
end
