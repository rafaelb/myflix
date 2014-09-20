class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :admin?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def admin?
    !!current_user.admin
  end

  def require_admin
    if !admin?
      flash[:error] = "ACCESS DENIED!!!"
      redirect_to root_path
    end
  end

  def require_user
    if !logged_in?
      flash[:error] = "Must be logged in to do that!"
      redirect_to login_path
    end
  end

  def require_guest
    if logged_in?
      redirect_to home_path
    end
  end

end
