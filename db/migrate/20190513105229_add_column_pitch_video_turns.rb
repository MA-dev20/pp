class AddColumnPitchVideoTurns < ActiveRecord::Migration[5.2]
  def change
    add_column :turns, :recorded_pitch, :string
  end
end
