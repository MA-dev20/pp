class AdminSessionController < ApplicationController
    
  def new_coach
  end
    
  def create_coach
    @admin = Admin.find_by(email: params[:session][:email])
    if @admin && @admin.authenticate(params[:session][:password])
      admin_login @admin
      redirect_to dash_admin_path
    else
      flash[:danger] = 'Unbekannte E-Mail/Passwort Kombination'
      redirect_to register_coach_path
    end
  end
    
  def new_company
  end
    
  def create_company
    @admin = Admin.find_by(email: params[:session][:email])
    if @admin && @admin.authenticate(params[:session][:password])
      admin_login @admin
      redirect_to dash_admin_path
    else
      flash[:danger] = 'Unbekannte E-Mail/Passwort Kombination'
      redirect_to register_company_path
    end
  end
    
  def destroy
    admin_logout
    flash[:success] = 'Erfolgreich ausgeloggt!'
    redirect_to root_path
  end
end
