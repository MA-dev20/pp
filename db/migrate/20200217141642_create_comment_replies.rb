class CreateCommentReplies < ActiveRecord::Migration[5.2]
  def change
    create_table :comment_replies do |t|
	  t.belongs_to :comment, foreign_key: true
	  t.belongs_to :admin, foreign_key: true
	  t.belongs_to :user, foreign_key: true
	  t.string :text
      t.timestamps
    end
  end
end
