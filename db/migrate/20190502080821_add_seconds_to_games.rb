class AddSecondsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :wait_seconds, :integer, default: 80
    add_column :games, :own_words, :boolean, default: false
  end
end
