class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.belongs_to :turn, foreign_key: true
      t.integer :user_id
      t.integer :admin_id
      t.integer :ges
      t.integer :body
      t.integer :creative
      t.integer :rhetoric
      t.integer :spontan

      t.timestamps
    end
  end
end
