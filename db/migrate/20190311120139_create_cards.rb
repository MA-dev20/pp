class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.belongs_to :admin, foreign_key: true
      t.string :card_id
      t.timestamps
    end
  end
end
