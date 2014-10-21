class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.present? ? "Rating: #{object.rating}/5.0" : "N/A"
  end

end