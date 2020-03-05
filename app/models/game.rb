class Game < ApplicationRecord
  include Basket
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable
  belongs_to :admin
  belongs_to :team
  belongs_to :turn, required: false
  belongs_to :custom_rating, required: false
  has_one :game_rating, dependent: :destroy
  has_many :turns, dependent: :destroy
  has_many :turn_ratings
  
  has_many :custom_rating_criteria
  has_many :turn_rating_criteria
  has_many :user_rating_criteria
  has_many :game_rating_criteria


  has_one :catchword_basket , class_name: "CatchwordsBasket", dependent: :destroy
  has_one :objection_basket , class_name: "ObjectionsBasket", dependent: :destroy

  has_many :users, through: :turns
  
  after_commit :callback, 
  if: proc { |record| 
    record.previous_changes.key?(:state) &&
      record.previous_changes[:state].first != record.previous_changes[:state].last
  }

  def callback
    ActionCable.server.broadcast "game_#{self.id}_channel",
        game_state: self.state, game_admin_id: self.admin_id
  end

  def has_turn_of_user? current_user
    turns = self.turns.where(user_id: current_user.id).where.not(status: "ended")
    return false if turns.empty?
    return true
  end
end
