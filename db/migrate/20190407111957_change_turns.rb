class ChangeTurns < ActiveRecord::Migration[5.2]
  def change
    change_table :turns do |t|
      t.remove :word_id
      t.integer :word_id
    end
  end
end
