class AddVideoUploadingToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :video_uploading, :boolean, default: false
  end
end
