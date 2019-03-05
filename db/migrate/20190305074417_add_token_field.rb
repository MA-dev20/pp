class AddTokenField < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :token, :integer
  end
end
