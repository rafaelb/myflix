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
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    QueueItem.create(video_id: video.id, user: current_user, position: new_position) unless current_user_queued_video?(video)
  end

  def new_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def unqueue_video(queue_item)

    pos = queue_item.position
    queue_item.destroy
    reorder_positions(pos)

  end

  def reorder_positions(position)
    (position..current_user.queue_items.count).each do |v|
      queue_item = current_user.queue_items.where(position: v+1).first
      queue_item.position -= 1
      queue_item.save
    end
  end

end