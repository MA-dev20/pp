class CreateGameRatingCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :game_rating_criteria do |t|
      t.string :name
      t.integer :value
      t.references :team, foreign_key: true
      t.references :rating_criteria, foreign_key: true
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
