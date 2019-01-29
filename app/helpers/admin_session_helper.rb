module AdminSessionHelper
    
  def admin_login(admin)
    session[:admin_id] = admin.id
  end
    
  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end
    
  def admin_logged_in?
    !current_admin.nil?
  end
    
  def admin_logout
    session.delete(:admin_id)
    @current_admin = nil
  end
    
  def require_admin
    unless admin_logged_in?
      flash[:danger] = 'Bitte logge dich ein!'
      redirect_to root_path
    end
  end
end