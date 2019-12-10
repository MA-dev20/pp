class Video < ApplicationRecord
    belongs_to :admin
    mount_uploader :file, PitchUploader
end
