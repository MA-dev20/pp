class Count < ApplicationRecord
    
  
    after_update_commit do
        CountBroadcastJob.perform_later(self)
    end
  
  end
  