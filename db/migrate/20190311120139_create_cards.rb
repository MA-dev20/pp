class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.references :admin
      t.string :card_token_id
      t.timestamps
    end
  end
end
