module RootSessionHelper
    
  def root_login(root)
    session[:root_id] = root.id
  end
    
  def current_root
    @current_root ||= Root.find_by(id: session[:root_id])
  end
    
  def root_logged_in?
    !current_root.nil?
  end
    
  def root_logout
    session.delete(:root_id)
    @current_root = nil
  end
    
  def require_root
    unless root_logged_in?
      flash[:danger] = 'Bitte logge dich ein!'
      redirect_to root_login_path
    end
  end
	
  def is_root?
	if @current_root.role == 'vertrieb'
	  return false
	else
	  return true
	end
  end

end
