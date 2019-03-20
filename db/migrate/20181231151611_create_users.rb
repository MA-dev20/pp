class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.belongs_to :admin, foreign_key: true
      t.string :company_name
      t.string :email
      t.string :password_digest
      t.string :fname
      t.string :lname
      t.string :avatar
      t.boolean :accepted

      t.timestamps
    end
  end
end
