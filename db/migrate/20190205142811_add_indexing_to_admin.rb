class AddIndexingToAdmin < ActiveRecord::Migration[5.2]
  def change
    add_index :admins, :company_name
    add_index :admins, :email
    add_index :admins, :fname
    add_index :admins, :lname
    add_index :admins, :coach
    add_index :admins, :company
  end
end
