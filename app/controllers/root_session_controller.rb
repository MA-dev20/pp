class RootSessionController < ApplicationController
  layout 'main'
  def new
  end
    
  def create
    @root = Root.find_by(username: params[:session][:username])
    if @root && @root.authenticate(params[:session][:password])
      root_login @root
      redirect_to backoffice_path
    else
      flash[:danger] = 'Unbekannte Username/Passwort Kombination!'
      redirect_to root_path
    end
  end
    
  def destroy
    root_logout
    redirect_to root_path
  end
end
