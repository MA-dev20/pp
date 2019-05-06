class CatchwordsBasket < ApplicationRecord
  belongs_to :admin, required: false
  belongs_to :game, required: false
  has_and_belongs_to_many :words, join_table: 'catchwords_basket_words'
end
