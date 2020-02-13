class CreateBlogParagraphs < ActiveRecord::Migration[5.2]
  def change
    create_table :blog_paragraphs do |t|
	  t.belongs_to :blog
	  t.string :title
	  t.string :text
      t.timestamps
    end
  end
end
