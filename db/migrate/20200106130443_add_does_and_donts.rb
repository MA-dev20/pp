class AddDoesAndDonts < ActiveRecord::Migration[5.2]
  def change
	change_table :admins do |t|
	  t.text :does
	  t.text :donts
	end
  end
end
