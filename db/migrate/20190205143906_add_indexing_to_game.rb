class AddIndexingToGame < ActiveRecord::Migration[5.2]
  def change
    add_index :games, :state
    add_index :games, :current_turn
    add_index :games, :active
  end
end
