class UsersCustomRating < ApplicationRecord
  belongs_to :custom_rating
  belongs_to :user
end
