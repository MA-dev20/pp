class AddVideoToggleToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :video_toggle, :boolean, default: false
  end
end
