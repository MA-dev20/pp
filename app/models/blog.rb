class Blog < ApplicationRecord
  mount_uploader :image, HqPicUploader
  has_many :blog_paragraphs
end
