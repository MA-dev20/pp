class AddAdminFileds < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :plan_id, :string
    add_column :admins, :plan_type, :integer
    add_column :admins, :subscription_id, :string
    add_column :admins, :plan_users, :integer
  end
end
