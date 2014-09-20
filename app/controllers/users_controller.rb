class UsersController < ApplicationController
  before_action 'require_guest', only: [:new, :create, :new_with_invitation_token]
  before_action 'require_user', only: :show
  before_action 'set_user', only: [:show]

  def index

  end

  def show

  end

  def new
    @user = User.new
    @referer_id = nil
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      process_payment
      @user.save
      flash[:notice] = "User Registered!"
      UserMailer.delay.welcome_email(@user)
      redirect_to root_path

    else
      render :new
    end
  end




  def edit

  end

  def update

  end

  def new_with_invitation_token
    @invite = Invite.find_by_token(params[:token])
    if @invite
      if User.where(email: @invite.recipient_email).first
        flash[:notice] = "You are already registered! Login below!"
        redirect_to login_path
      else
        @user = User.new(email: @invite.recipient_email, full_name: @invite.recipient_name)
        render :new
      end
    else
      flash[:error] = "Invalid token"
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :password, :referer_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def process_payment
    @amount = 999

    customer = Stripe::Customer.create(
        :email => @user.email,
        :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
        :customer    => customer.id,
        :amount      => @amount,
        :description => 'Rails Stripe customer',
        :currency    => 'usd'
    )
  rescue Stripe::CardError => e

    flash[:error] = e.message
    redirect_to register_path
  end
end