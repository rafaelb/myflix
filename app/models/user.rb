class User < ActiveRecord::Base
  has_secure_password validations: false
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  has_many :reviews
  has_many :queue_items, -> { order(:position) }
end