class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.belongs_to :admin, foreign_key: true
      t.string :name
      t.string :logo

      t.timestamps
    end
  end
end
