class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :type_of_comment
      t.integer :time_of_video
      t.string :title
      t.references :turn, foreign_key: true

      t.timestamps
    end
  end
end
