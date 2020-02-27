class AddCustomRatingIdToDifferentTables < ActiveRecord::Migration[5.2]
  def change
    add_reference :turn_rating_criteria, :custom_rating, foreign_key: true
    add_reference :user_rating_criteria, :custom_rating, foreign_key: true
    add_reference :game_rating_criteria, :custom_rating, foreign_key: true
  end
end
