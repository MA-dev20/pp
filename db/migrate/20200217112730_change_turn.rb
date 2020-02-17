class ChangeTurn < ActiveRecord::Migration[5.2]
  def change
	change_table :turns do |t|
	  t.boolean :released, default: false
	end
  end
end
