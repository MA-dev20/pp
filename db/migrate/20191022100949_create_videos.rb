class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.belongs_to :admin, foreign_key: true
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
