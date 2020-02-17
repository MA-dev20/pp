class CommentReply < ApplicationRecord
  belongs_to :comment
  belongs_to :admin, required: false
  belongs_to :user, required: false
end
