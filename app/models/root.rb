class Root < ApplicationRecord
  has_secure_password
  mount_uploader :avatar, PicUploader
end
