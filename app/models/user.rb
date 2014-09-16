class User < ActiveRecord::Base
  include Tokenable
  has_secure_password validations: false
  after_create :set_followers_and_delete_invites
  validates :email, presence: true, uniqueness: true
  validates :full_name, presence: true
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order(:position) }
  has_many :relationships, foreign_key: 'follower_id'
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship'
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :invites, foreign_key: 'inviter_id'


  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attribute(:position, index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def following?(other_user)
    relationships.exists?(followed_id: other_user.id)
  end

  def followed_by?(other_user)
    reverse_relationships.exists?(follower_id: other_user.id)
  end

  def follow(other_user)
    relationships.create(followed_id: other_user.id) unless following?(other_user) || other_user.id == id
  end

  def unfollow(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  def set_password(pword)
    self.password = pword
    generate_token
    save
  end

  private

  def set_followers_and_delete_invites
    invites = Invite.where(recipient_email: email)
    invites.each do |i|
      inviter = i.inviter
      inviter.follow(self)
      self.follow(inviter)
      i.delete
    end
  end
end