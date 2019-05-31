class AddClickTimeInTurns < ActiveRecord::Migration[5.2]
  def change
  	add_column :turns, :click_time, :datetime
  end
end
