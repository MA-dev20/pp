class NewFieldInTurnRatings < ActiveRecord::Migration[5.2]
  def change
  	add_column :turn_ratings,:ended, :boolean, default: false
  end
end
