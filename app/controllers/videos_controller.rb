class VideosController < ApplicationController
  before_action :set_video, only: [:update, :destroy]
    
  def new
  end
    
  def create
    @video = Video.new(video_params)
    @video.file = params[:file]
    if !@video.save
      flash[:danger] = 'Konnte Video nicht speichern!'
    end
    redirect_to dash_admin_video_tool_path
  end
	
  def update
	if !@video.update(video_params)
      flash[:danger] = "Konnte Video nicht updaten!"
	end
	redirect_to dash_admin_video_edit_path(@video)
  end
	
  def destroy
	if !@video.destroy
	  flash[:danger] = 'Konnte Video nicht löschen!'
	  redirect_to dash_admin_video_edit_path(@video)
	  return
	else
	  redirect_to dash_admin_video_tool_path
	end
	
  end

  private
	def set_video
	  @video = Video.find(params[:video_id])
	end
    def video_params
      params.require(:video).permit(:name, :file, :admin_id)
    end
end
