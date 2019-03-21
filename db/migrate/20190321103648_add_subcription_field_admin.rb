class AddSubcriptionFieldAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :admin_subscription_id, :string
  end
end
