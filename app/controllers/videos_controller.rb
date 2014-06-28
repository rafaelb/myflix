class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update]
  before_action :require_user

  def index
    @categories = Category.all
  end


  def search
    @videos = Video.search_by_title(params[:search_term])
  end


  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :small_cover_url, :large_cover_url)
  end

  def set_video
    @video = Video.find(params[:id])
  end

end