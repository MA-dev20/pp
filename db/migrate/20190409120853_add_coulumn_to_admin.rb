class AddCoulumnToAdmin < ActiveRecord::Migration[5.2]
  def change
  	add_column :admins, :verification_code_confirm, :boolean, default:  false
  end
end
