class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_subscription_id
      t.references :plan
      t.timestamps
    end
  end
end
