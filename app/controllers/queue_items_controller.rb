class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    unqueue_video(queue_item) if queue_item.user == current_user
    current_user.normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_positions
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position"
    end
    redirect_to my_queue_path
  end
  private

  def queue_video(video)
    QueueItem.create(video_id: video.id, user: current_user, position: new_position) unless current_user.queued_video?(video)
  end

  def new_position
    current_user.queue_items.count + 1
  end


  def unqueue_video(queue_item)
    pos = queue_item.position
    queue_item.destroy
  end


  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position], rating: queue_item_data[:rating]) if queue_item.user == current_user
      end
    end
  end


end