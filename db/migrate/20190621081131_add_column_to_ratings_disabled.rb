class AddColumnToRatingsDisabled < ActiveRecord::Migration[5.2]
  def change
    add_column :ratings, :disabled, :boolean, default: false
  end
end
