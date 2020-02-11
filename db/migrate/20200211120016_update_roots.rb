class UpdateRoots < ActiveRecord::Migration[5.2]
  def change
	add_column :roots, :email, :string
	add_column :roots, :role, :string
  end
end
