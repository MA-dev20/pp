class AddVideoToGame < ActiveRecord::Migration[5.2]
  def change
	change_table :games do |t|
		t.integer :video
		t.boolean :video_is_pitch
	end
  end
end
