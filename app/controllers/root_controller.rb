class RootController < ApplicationController
  before_action :require_root, :set_root, only: [:edit, :update, :destroy]
    
  def new
  end
    
  def create
    @root = Root.new(root_params)
    if @root.save
      flash[:success] = 'Superuser erstellt!'
      redirect_to backoffice_path
    else
      flash[:danger] = 'Konnte Superuser nicht erstellen!'
      redirect_to backoffice_path
    end
  end
    
  def edit
  end
    
  def update
    @root.update(root_params)
  end
    
  def destroy
    @root.destroy
  end
    
  private
    def set_root
      @root = Root.find(:root_id)
    end
    
    def root_params
      params.require(:root).permit(:username, :password)
    end
end
