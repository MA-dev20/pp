class UpdateRoot < ActiveRecord::Migration[5.2]
  def change
	add_column :roots, :avatar, :string
  end
end
