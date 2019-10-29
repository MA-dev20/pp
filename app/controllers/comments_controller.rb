class CommentsController < ApplicationController
  before_action :set_turn
    
  def new
  end
    
  def create
    @comment = @turn.comments.new(comments_params)
    if !@comment.save
      flash[:danger] = 'Konnte Comment nicht speichern!'
    end
    redirect_to dash_admin_video_details_path(@turn)
  end
  private
    def set_turn
      @turn = Turn.find(params[:turn_id])
      @admin = current_admin
    end
    
    def comments_params
      params.require(:comment).permit(:type_of_comment, :title, :time_of_video)
    end
end