class CreateTurnRatingCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :turn_rating_criteria do |t|
      t.string :name
      t.integer :value
      t.boolean :ended, default: false
      t.references :rating_criteria, foreign_key: true
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true
      t.references :admin, foreign_key: true
      t.references :turn, foreign_key: true

      t.timestamps
    end
  end
end
