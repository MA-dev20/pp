class Turn < ApplicationRecord
  include VideosHelper

  belongs_to :game
  belongs_to :user, required: false
  belongs_to :admin, required: false
  belongs_to :word, required: false
  has_one :turn_rating, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comments, dependent: :destroy  
  mount_uploader :recorded_pitch, PitchUploader
  after_save :save_duration_for_pitch
  
  TURN_QUERY = 'users.*,(select count(*) from turns t1 where t1.user_id=users.id and place=1) as gold_count, (select count(*) from turns t1 where t1.user_id=users.id and place=2) as silver_count, (select count(*) from turns t1 where t1.user_id=users.id and place=3) as bronze_count'
    
  scope :playable, -> { where(play:true, played: false) }
    
  def findUser
    if user_id
      User.find(user_id)
    else
      Admin.find(admin_id)
    end
  end
  def save_duration_for_pitch
    if self.recorded_pitch.present? && self.recorded_pitch_duration.nil?
      movie = FFMPEG::Movie.new(self.recorded_pitch.path)
      self.recorded_pitch_duration = movie.duration
      self.save!
      TranslateVideoJob.perform_later(self)  
    end
  end

  def video_to_text
    values = translate_video(self.recorded_pitch.path, self.game.wait_seconds)
    # values = translate_video("sdfs", 80)
    self.video_text = values[0]
    self.do_words = values[1]
    self.dont_words = values[2]
    self.words_count = values[3]
    self.save!
  end
end



Turn.class_eval do
  def review
    self.click_time = DateTime.now
    self.save
  end
end
