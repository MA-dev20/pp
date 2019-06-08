class Add2playerVote < ActiveRecord::Migration[5.2]
  def change
    change_table :games do |t|
      t.integer :turn1, foreign_key: true
      t.integer :turn2, foreign_key: true
    end
    change_table :turns do |t|
      t.integer :counter
    end
  end
end
