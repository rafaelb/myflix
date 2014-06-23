class SessionsController < ApplicationController
  before_action 'require_two_factor', only: :pin
  before_action 'require_guest', only: [:new, :create]

  def new

  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      login_user!(user)
    else
      flash.now[:error] = "Invalid login details!!!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end


  private

  def login_user!(user)
    session[:user_id] = user.id
    flash[:notice] = "You have succesfully logged in!"
    redirect_to home_path
  end


end