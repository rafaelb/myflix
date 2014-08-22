class UsersController < ApplicationController
  before_action 'require_guest', only: [:new, :create]
  before_action 'require_user', only: :show
  before_action 'set_user', only: [:show]

  def index

  end

  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User Registered!"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit

  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end