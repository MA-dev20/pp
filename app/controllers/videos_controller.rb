class VideosController < ApplicationController
    
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

  private    
    def video_params
      params.require(:video).permit(:name, :file, :admin_id)
    end
end
