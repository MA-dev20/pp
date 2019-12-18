class AddVideoTextToTurns < ActiveRecord::Migration[5.2]
  def change
    add_column :turns, :video_text, :text
  end
end
