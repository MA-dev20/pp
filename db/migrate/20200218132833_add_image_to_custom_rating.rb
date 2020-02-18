class AddImageToCustomRating < ActiveRecord::Migration[5.2]
  def change
    add_column :custom_ratings, :image, :integer
  end
end
