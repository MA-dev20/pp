class AddReplayToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :replay, :boolean, default: false
  end
end
