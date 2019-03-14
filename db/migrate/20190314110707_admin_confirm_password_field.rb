class AdminConfirmPasswordField < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :password_confirm, :string
  end
end
