class ChangeUser < ActiveRecord::Migration[5.2]
  def change
	change_table :users do |t|
	  t.remove :encrypted_pw
	  t.string :encrypted_password, null: false, default: ""
	  t.string   :reset_password_token
      t.datetime :reset_password_sent_at
	  t.datetime :remember_created_at
	end
  end
end
