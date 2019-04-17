class AddAdminTurnInTurns < ActiveRecord::Migration[5.2]
  def change
    add_column :turns, :admin_turn, :boolean, default: false
  end
end
