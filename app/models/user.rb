class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }
  has_many :relationships, foreign_key: 'follower_id'
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship'
  has_many :followers, through: :reverse_relationships, source: :follower

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attribute(:position, index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end
end