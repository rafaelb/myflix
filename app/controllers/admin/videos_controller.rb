class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = 'Video Saved'
      redirect_to video_path(@video)
    else
      flash[:error] = "Invalid attributes"
      render :new
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end
end