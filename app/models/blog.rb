class Blog < ApplicationRecord
  mount_uploader :image, PicUploader
end
