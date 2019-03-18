class AddStatusInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :integer , default: 2
  end
end
