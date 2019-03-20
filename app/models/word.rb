class Word < ApplicationRecord
  mount_uploader :sound, SoundUploader
end
