class AddImageIdToCatchwordsBasket < ActiveRecord::Migration[5.2]
  def change
    add_column :catchwords_baskets, :image, :integer
  end
end
