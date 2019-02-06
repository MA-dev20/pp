class AddIndexingToTurn < ActiveRecord::Migration[5.2]
  def change
    add_index :turns, :place
    add_index :turns, :play
    add_index :turns, :played
  end
end
