class AddPlayedFieldsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :not_played_count, :integer, default: 0
    add_column :games, :choose_counter, :integer, default: 0
  end
end
