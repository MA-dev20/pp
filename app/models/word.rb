class Word < ApplicationRecord
  mount_uploader :sound, SoundUploader
  has_and_belongs_to_many :catchword_baskets, join_table: 'catchwords_basket_words', class_name: 'CatchwordsBasket'
end
