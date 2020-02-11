class CreateVertrieb < ActiveRecord::Migration[5.2]
  def change
    create_table :vertriebs do |t|
	  t.string :name
	  t.string :password
	  t.string :state
	  t.string :fname
	  t.string :avatar
	  t.string :logo
	  t.string :game_password
	  t.string :team_name
	  t.timestamps
    end
  end
end
