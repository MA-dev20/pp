class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :company_name
      t.string :email
      t.string :password_digest
      t.string :fname
      t.string :lname
      t.string :street
      t.string :city
      t.string :avatar
      t.string :logo
      t.integer :employees
      t.integer :zipcode
      t.boolean :coach
      t.boolean :company

      t.timestamps
    end
  end
end
