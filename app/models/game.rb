class Game < ApplicationRecord
  include Basket
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable
  belongs_to :admin
  belongs_to :team
  belongs_to :turn, required: false
  has_one :game_rating, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings
  
  has_one :catchword_basket , class_name: "CatchwordsBasket", dependent: :destroy

  has_many :users, through: :turns
  
  after_commit :callback, 
  if: proc { |record| 
    record.previous_changes.key?(:state) &&
      record.previous_changes[:state].first != record.previous_changes[:state].last
  }

  def callback
      NotificationBroadcastJob.perform_later(self)
  end
end
