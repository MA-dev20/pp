class CountChannel < ApplicationCable::Channel
    def subscribed
      stream_from "count_#{params['game_id']}_channel"
    end
    
    def unsubscribed
    end
    
    def send_message(data)
    end
end