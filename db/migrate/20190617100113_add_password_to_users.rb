class AddPasswordToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_pw, :string
    add_column :users, :street, :string
    add_column :users, :zipcode, :string
    add_column :users, :city, :string
    add_column :users, :logo, :string
  end
end
