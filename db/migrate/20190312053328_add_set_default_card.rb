class AddSetDefaultCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :set_default_card, :boolean
    add_column :cards, :stripe_card_id, :string
    add_column :cards, :last_4_cards_digit, :integer
    add_column :cards, :expiry_month, :integer
    add_column :cards, :expiry_year, :integer
    add_column :cards, :card_brand, :string
  end
end
