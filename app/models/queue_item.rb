class QueueItem< ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :video, :user, :position
  validates_uniqueness_of :video_id, scope: :user_id
  validates :position, numericality: { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_attribute(:rating, new_rating)
    else
      review = Review.new(user_id: user_id, video_id: video_id, rating: new_rating)
      review.save(validate: false)
    end
  end

  private
  def review
    @review ||= Review.where(user_id: user_id, video_id: video_id).first
  end
end