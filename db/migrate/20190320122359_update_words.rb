class UpdateWords < ActiveRecord::Migration[5.2]
  def change
    change_table :words do |t|
      t.boolean :free
    end
  end
end
