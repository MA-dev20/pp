class AddIndexingToTeamWord < ActiveRecord::Migration[5.2]
  def change
    add_index :words, :name
    add_index :words, :sound
  end
end
