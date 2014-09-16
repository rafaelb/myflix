class UserMailer < ActionMailer::Base
  default from: "myflix@myflix.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to MyFlix")
  end

  def send_forgot_password(user)
    @user = user
    mail(to: @user.email, subject: "Please reset your password")
  end

  def send_invite(sender, rcv_name, rcv_email, message, token)
    @token = token
    @sender = sender
    @rcv_name = rcv_name
    @rcv_email = rcv_email
    @message = message
    mail(from: @sender.email, to: @rcv_email, subject: "You are invited to join MyFlix")
  end
end
