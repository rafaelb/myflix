class Video < ActiveRecord::Base
  belongs_to :category
  validates :category, presence: true
  validates :title, presence: true
  validates :description, presence: true
  has_many :reviews

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title like ?", "%#{search_term}%").order(:created_at)
  end
end