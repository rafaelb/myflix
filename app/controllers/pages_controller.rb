class PagesController < ApplicationController
  def front

  end

  def index
    if logged_in?
      redirect_to videos_path
    else
      render :front
    end
  end
end
