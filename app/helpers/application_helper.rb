module ApplicationHelper
  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map {|num| [pluralize(num, "Star"), num]}, selected)
    #options_for_select([['5 Stars', 5], ['4 Stars', 4], ['3 Stars', 3], ['2 Stars', 2], ['1 Star', 1]])
  end

  def queue_button
    unless current_user.queued_video?(@video)
      link_to "+ My Queue", queue_items_path(video_id: @video.id), method: :post, class: 'btn btn-default'
    end
  end
end
