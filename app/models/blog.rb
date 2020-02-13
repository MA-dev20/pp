class Blog < ApplicationRecord
  mount_uploader :image, PicUploader
  has_many :blog_paragraphs
end
