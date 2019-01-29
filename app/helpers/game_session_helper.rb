module GameSessionHelper
    
  def game_login(game)
    session[:game_id] = game.id
  end
        
  def game_user_login(user)
    session[:game_user_id] = user.id
  end
        
  def game_admin_login(admin)
    session[:game_admin_id] = admin.id
  end
    
  def current_game
    @current_game ||= Game.find_by(id: session[:game_id])
  end

  def current_game_user
    @current_game_user ||= User.find_by(id: session[:game_user_id])
  end
        
  def current_game_admin
    @current_game_admin ||= Admin.find_by(id: session[:game_admin_id])
  end
    
  def game_logged_in?
    !current_game.nil?
  end

  def game_user_logged_in?
    !current_game_user.nil?
  end
        
  def game_admin_logged_in?
    !current_game_admin.nil?
  end
    
  def game_logout
    session.delete(:game_id)
    session.delete(:game_user_id)
    session.delete(:game_admin_id)
    @current_game = nil
    @current_game_user = nil
    @current_game_admin = nil
  end
    
  def require_game
    unless game_logged_in?
      flash[:danger] = 'Bitte logge dich ein!'
      redirect_to root_path
    end
  end

  def require_game_user
    unless game_user_logged_in?
      flash[:danger] = 'Bitte logge dich ein!'
      redirect_to root_path
    end
  end
        
  def require_game_admin
    unless game_admin_logged_in?
      flash[:danger] = 'Bitte logge dich ein!'
      redirect_to root_path
    end
  end
        
end
