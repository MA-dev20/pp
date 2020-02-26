class UsersCustomRating < ApplicationRecord
  belongs_to :custom_rating
  belongs_to :user, required: false
  belongs_to :admin, required: false
end
