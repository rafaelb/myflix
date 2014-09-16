class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def expired

  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.set_password(params[:password])
      flash[:success] = "Password Reset!!!"
      redirect_to login_path
    else
      redirect_to expired_token_path
    end
  end
end