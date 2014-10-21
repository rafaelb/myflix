class SignUp
  attr_reader :params, :user, :error
  def initialize(params={})
    @params = params
    @user = User.new(user_params)
  end

  def register
    if @user.valid?
      customer = StripeWrapper::Customer.create(
          card: params[:stripeToken],
          email: @user.email
      )
      if customer.succesful?
        @user.stripe_token = customer.id
        @user.save
        UserMailer.delay.welcome_email(@user)
        @status = :success
        self
      else
        @status = :failure
        @error = customer.error_message
        self
      end
    else
      @status = :failure
      @error = "Invalid user details"
      self
    end
  end

  def success?
    @status == :success
  end

  private
  def user_params
    parameters = ActionController::Parameters.new(params)
    parameters.require(:user).permit(:full_name, :email, :password, :referer_id)
  end
end