class CreateRatingCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :rating_criteria do |t|
      t.string :name
      t.integer :value
      t.references :custom_rating, foreign_key: true

      t.timestamps
    end
  end
end
