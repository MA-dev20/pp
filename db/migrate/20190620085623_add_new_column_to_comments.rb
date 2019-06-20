class AddNewColumnToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :release_it, :boolean, default: false
  end
end
