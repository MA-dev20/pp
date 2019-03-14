class AdminFieldsforPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :annually, :boolean
    add_column :admins, :monthy, :boolean

  end
end
