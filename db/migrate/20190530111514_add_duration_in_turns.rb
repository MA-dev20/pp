class AddDurationInTurns < ActiveRecord::Migration[5.2]
  def change
  	add_column :turns, :recorded_pitch_duration , :integer
  end
end
