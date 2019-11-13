class ChangeAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :telephone, :string
    add_column :admins, :company_position, :string
    add_column :admins, :activated, :boolean
    add_column :admins, :message, :string
  end
end
