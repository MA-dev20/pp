class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.belongs_to :admin, foreign_key: true
      t.belongs_to :team, foreign_key: true
      t.string :state
      t.string :password
      t.bigint :current_turn
      t.boolean :active

      t.timestamps
    end
  end
end
