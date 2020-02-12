class Vertrieb < ApplicationRecord
  mount_uploader :avatar, PicUploader
  mount_uploader :logo, PicUploader
  belongs_to :root
  after_commit :callback
	
  def callback
	ActionCable.server.broadcast "vertrieb_#{self.id}_channel", vertrieb_state: self.state
  end
end
