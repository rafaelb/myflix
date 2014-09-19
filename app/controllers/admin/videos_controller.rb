class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    if @video.save
      flash[:success] = 'Video Saved'
      redirect_to video_path(@video)
    else
      flash[:error] = "Invalid attributes"
      render :new
    end
  end
end