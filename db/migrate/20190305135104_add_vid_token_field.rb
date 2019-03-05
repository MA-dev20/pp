class AddVidTokenField < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :vid_token, :integer
  end
end
