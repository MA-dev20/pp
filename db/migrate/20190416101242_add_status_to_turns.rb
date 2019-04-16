class AddStatusToTurns < ActiveRecord::Migration[5.2]
  def change
    add_column :turns, :status, :string, default: "pending"
  end
end
