class AddVideoUploadedStartToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :video_uploaded_start, :boolean, default: false
  end
end
