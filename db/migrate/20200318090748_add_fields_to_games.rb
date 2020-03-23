class AddFieldsToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :rating_option, :integer, default: 0
    add_column :games, :rating_user_id, :integer
  end
end
