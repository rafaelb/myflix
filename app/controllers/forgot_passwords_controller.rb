class ForgotPasswordsController < ApplicationController
  before_action :require_guest
  def new

  end

  def create
    user = User.where(email: params[:email]).first
    if user
      UserMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      flash[:error] = params[:email].blank? ? "Can't be blank!!!" : "Invalid email!!!"
      redirect_to forgot_password_path
    end
  end

  def confirm

  end
end