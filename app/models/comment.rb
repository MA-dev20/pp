class Comment < ApplicationRecord
  belongs_to :turn
  has_many :comment_replies, dependent: :destroy
end
