class TranslateVideoJob < ApplicationJob
  queue_as :default

  def perform(turn)
    turn.video_to_text()
  end
end
