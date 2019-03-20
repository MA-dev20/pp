class CreateUserRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_ratings do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :ges
      t.integer :body
      t.integer :creative
      t.integer :rhetoric
      t.integer :spontan

      t.timestamps
    end
  end
end
