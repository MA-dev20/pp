class AddUserIdInPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :user_id, :integer
 end
end
