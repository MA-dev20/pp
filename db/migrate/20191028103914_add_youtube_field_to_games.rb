class AddYoutubeFieldToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :youtube_url, :string
  end
end
