class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
	  t.string :image
	  t.string :text
	  t.string :title
      t.timestamps
    end
  end
end
