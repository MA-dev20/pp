class CreateTableCatchworldsBasketWords < ActiveRecord::Migration[5.2]
  def change
    create_table :catchwords_basket_words do |t|
      t.references :word, foreign_key: true
      t.references :catchwords_basket, foreign_key: true
    end
  end
end
