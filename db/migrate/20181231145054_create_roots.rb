class CreateRoots < ActiveRecord::Migration[5.2]
  def change
    create_table :roots do |t|
      t.string :username
      t.string :password_digest
      t.boolean :edit_words
      t.boolean :edit_admins
      t.boolean :edit_root

      t.timestamps
    end
  end
end
