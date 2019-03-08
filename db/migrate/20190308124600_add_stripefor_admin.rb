class AddStripeforAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :stripe_id, :string
  end
end
