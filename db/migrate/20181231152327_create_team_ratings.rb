class CreateTeamRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :team_ratings do |t|
      t.belongs_to :team, foreign_key: true
      t.integer :ges
      t.integer :body
      t.integer :creative
      t.integer :rhetoric
      t.integer :spontan

      t.timestamps
    end
  end
end
