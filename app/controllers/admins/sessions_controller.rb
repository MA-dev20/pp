class Admins::SessionsController < Devise::SessionsController
    def new
      redirect_to root_path(anchor: 'login')
    end
	def create
	  @admin = Admin.find_by(email: params[:admin][:email], )
	  @user = User.find_by(email: params[:admin][:email])
	  if @admin && @admin.valid_password?(params[:admin][:password])
		sign_in @admin
		redirect_to dash_admin_path
	  elsif @user && @user.valid_password?(params[:admin][:password])
		sign_in @user
		redirect_to dash_user_stats_path
	  else
		redirect_to root_path
	  end
	end
    protected
    def after_sign_in_path_for(resource)
      dash_admin_path
    end

    private 
    def admin_params
      params.require(:admin).permit(:id ,:email , :password)
    end
end