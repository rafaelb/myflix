class Invite < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: 'User'
  validates_presence_of :inviter
  validates_presence_of :recipient_name
  validates_presence_of :recipient_email
  validates_presence_of :message
  after_create :send_email

  private

  def send_email
    UserMailer.send_invite(inviter,recipient_name,recipient_email,message,token).deliver
  end
end