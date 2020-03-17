class AddMuteSoundToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :mute_sound, :boolean, default: false
  end
end
