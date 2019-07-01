class ObjectionsBasket < CatchwordsBasket
  belongs_to :admin, required: false
  belongs_to :game, required: false
  has_many :objection_basket_objections
  has_many :objections, through: :objection_basket_objections, class_name: 'Objection'
  default_scope { where(objection: true) }

  # has_and_belongs_to_many :objections, join_table: 'objection_basket_objections',  foreign_key: 'objection_id', inverse_of: :objection_baskets
end
