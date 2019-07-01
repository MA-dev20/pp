class AddTypeToCatchwords < ActiveRecord::Migration[5.2]
  def change
  	add_column :catchwords_baskets, :type, :string
  	add_column :catchwords_baskets, :objection, :boolean , :default => false
  	add_column :words, :type, :string
  	add_column :games, :use_peterobjections, :boolean, default: false
  	create_table :objection_basket_objections do |t|
      t.integer :objection_id
      t.integer :objections_basket_id
    end
  end
end
