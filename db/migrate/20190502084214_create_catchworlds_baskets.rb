class CreateCatchworldsBaskets < ActiveRecord::Migration[5.2]
  def change
    create_table :catchwords_baskets do |t|
      t.references :admin, foreign_key: true
      t.references :game, foreign_key: true
      t.timestamps
    end
  end
end
