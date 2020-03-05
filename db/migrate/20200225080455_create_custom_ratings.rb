class CreateCustomRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_ratings do |t|
      t.string :name
      t.integer :image
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end