class Video < ActiveRecord::Base
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  belongs_to :category
  validates :category, presence: true
  validates :title, presence: true
  validates :description, :video_url, presence: true
  has_many :reviews, -> { order(created_at: :desc) }

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title like ?", "%#{search_term}%").order(:created_at)
  end

  def rating
    return 0.0 if self.reviews.empty?
    total = 0
    self.reviews.each { |r| total += r.rating}
    (total.to_f / self.reviews.count).round(1)
  end
end