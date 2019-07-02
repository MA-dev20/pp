class Objection < Word
  mount_uploader :sound, SoundUploader
  has_many :objection_basket_objections
  has_many :objection_baskets , through: :objection_basket_objections, class_name: 'ObjectionsBasket', source: :objections_basket
  # has_and_belongs_to_many :objection_baskets, join_table: 'objection_basket_objections', class_name: 'ObjectionsBasket',foreign_key: 'objections_basket_id',  inverse_of: :objections
end
