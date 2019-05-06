class AddColumnToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :reset_pw_token, :string
  end
end
