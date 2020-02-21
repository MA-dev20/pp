class AddCustomRatingForeignKeyToDifferentTables < ActiveRecord::Migration[5.2]
  def change
    add_reference :turns, :custom_rating, foreign_key: true
    add_reference :games, :custom_rating, foreign_key: true
  end
end
