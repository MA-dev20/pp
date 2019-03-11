class AddExpirationField < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :expiration, :date
  end
end
