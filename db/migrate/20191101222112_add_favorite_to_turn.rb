class AddFavoriteToTurn < ActiveRecord::Migration[5.2]
  def change
    add_column :turns, :favorite, :boolean, default: false
  end
end
