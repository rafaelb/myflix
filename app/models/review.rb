class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates :video, presence: true
  validates :user, presence: true
  validates :rating, presence: true, :numericality => { :greater_than_or_equal_to =>  1, :less_than_or_equal_to => 5 }
  validates :content, presence: true
  #validates :rating, :numericality => { :greater_than_or_equal_to =>  1, :less_than_or_equal_to => 5 }
end