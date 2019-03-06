class ChangeVidToken < ActiveRecord::Migration[5.2]
  def change
    change_column :admins, :vid_token, :string
  end
end
