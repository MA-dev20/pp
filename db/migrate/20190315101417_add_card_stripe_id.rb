class AddCardStripeId < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :stripe_custommer_id, :string

  end
end
