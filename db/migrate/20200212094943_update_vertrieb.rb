class UpdateVertrieb < ActiveRecord::Migration[5.2]
  def change
	change_table :vertriebs do |t|
	  t.belongs_to :root, foregin_key: true
	end
  end
end
