module VertriebSessionHelper
  
  def vertrieb_login(vertrieb)
	session[:vertrieb_id] = vertrieb.id
  end
  def current_vertrieb
	@current_vertrieb ||= Vertrieb.find_by(id: session[:vertrieb_id])
  end
	
  def vertrieb_logged_in?
	!current_vertrieb.nil?
  end
	
  def vertrieb_logout
	session.delete(:vertrieb_id)
	@current_vertrieb = nil
  end

  def require_vertrieb
	unless vertrieb_logged_in?
	  flash[:danger] = "Bitte logge dich ein!"
	  redirect_to vertrieb_login_path
	end
  end
end