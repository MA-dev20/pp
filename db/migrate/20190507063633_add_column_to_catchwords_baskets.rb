class AddColumnToCatchwordsBaskets < ActiveRecord::Migration[5.2]
  def change
    add_column :catchwords_baskets, :name, :string
  end
end
