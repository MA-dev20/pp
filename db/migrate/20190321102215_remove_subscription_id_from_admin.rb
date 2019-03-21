class RemoveSubscriptionIdFromAdmin < ActiveRecord::Migration[5.2]
  def change
    remove_column :admins, :subscription_id, :string
  end
end
