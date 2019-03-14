class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :amount
      t.string :product_name
      t.string :interval
      t.string :currency
      t.string :stripe_plan_id
      t.references :admin
      t.timestamps
    end
  end
end
