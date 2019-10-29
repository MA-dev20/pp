class ChangeUserRatings < ActiveRecord::Migration[5.2]
  def change
    add_column :user_ratings, :change_ges, :integer
    add_column :user_ratings, :change_body, :integer
    add_column :user_ratings, :change_creative, :integer
    add_column :user_ratings, :change_rhetoric, :integer
    add_column :user_ratings, :change_spontan, :integer
  end
end
