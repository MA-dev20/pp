class AddIndexUsernameToRoot < ActiveRecord::Migration[5.2]
  def change
    add_index :roots, :username
  end
end
