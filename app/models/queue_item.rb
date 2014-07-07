class QueueItem< ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :video, :user, :position
  validates_uniqueness_of :position, :video_id, scope: :user_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.where(user_id: user_id, video_id: video_id).first
    review.rating if review
  end
end