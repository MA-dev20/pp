class AdminsController < ApplicationController
  skip_before_action :check_expiration_date
  before_action :require_root, :set_vars
  def destroy
    if @admin.destroy
      flash[:success] = 'Spieler erfolgreich gelöscht!'
      redirect_to backoffice_admins_path
    else
      flash[:danger] = 'Konnte Spieler nicht löschen!'
      redirect_to backoffice_admins_path
    end
  end





    
  private
    def set_vars
      @root = current_root
      @admin = Admin.find(params[:admin_id])
    end
end
