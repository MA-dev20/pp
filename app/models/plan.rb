class Plan < ApplicationRecord
    belongs_to :admin
    has_one :subscription, dependent: :destroy
end
