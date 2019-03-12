class RemoveFieldFromCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :cards, :card_token_id, :string
  end
end
