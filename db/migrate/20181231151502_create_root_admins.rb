class CreateRootAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :root_admins do |t|
      t.belongs_to :root, foreign_key: true
      t.belongs_to :admin, foreign_key: true

      t.timestamps
    end
  end
end
