class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :plan_id
      t.string :subscription_id
      t.integer :user_id
      t.references :admin 
      t.timestamps
    end
  end
end
