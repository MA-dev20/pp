class CreateUsersCustomRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :users_custom_ratings do |t|
      t.references :custom_rating, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
