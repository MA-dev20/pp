class AddColumnToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :uses_peterwords, :boolean, default: false
  end
end
