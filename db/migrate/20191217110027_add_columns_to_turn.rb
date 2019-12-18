class AddColumnsToTurn < ActiveRecord::Migration[5.2]
  def change
    change_table :turns do |t|
      t.integer :do_words, default: 0
      t.integer :dont_words, default: 0
      t.integer :words_count, default: 0
    end
  end
end
