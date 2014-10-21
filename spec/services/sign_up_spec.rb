require 'rails_helper'

describe SignUp do
  context "valid attributes" do
    before(:each) do
      customer = double('customer', succesful?: true, id: 'dklgjdfl')
      expect(StripeWrapper::Customer).to receive(:create) { customer }
      @signup = SignUp.new(user: Fabricate.attributes_for(:user), stripeToken: '123')
      @signup.register
    end
    it "should set the success? variable to true" do
      expect(@signup.success?).to be_truthy
    end

    it "should create the user" do
      expect(User.count).to eq(1)
    end

    it "should send out the welcome email" do
      expect(ActionMailer::Base.deliveries).to_not be_empty
    end
    it "sends email to the right recepient" do
      message = ActionMailer::Base.deliveries.last
      expect(message.to).to eq([User.last.email])

    end
    it "has the right content" do
      message = ActionMailer::Base.deliveries.last
      expect(message.body).to include("Hello #{User.last.full_name}")
    end
  end

  context "valid referer" do
    before :each do
      customer = double('customer', succesful?: true, id: 'sdfjsdlk')
      expect(StripeWrapper::Customer).to receive(:create) { customer }
      @referer = Fabricate(:user)
      @invite = Invite.create(inviter: @referer, recipient_name: "New User", recipient_email: "new@user.com", message: 'ffdsjkfhsdjkfh')
      @signup = SignUp.new(user: Fabricate.attributes_for(:user, email: "new@user.com"), stripeToken: '123')
      @signup.register
    end

    it "should set the referer as follower of the new user" do
      expect(User.last.followed_by?(@referer)).to be_truthy
    end

    it "should set the user as follower of the referer" do
      expect(@referer.followed_by?(User.last)).to be_truthy
    end

    it "expires the invite" do
      expect(Invite.first).to be_nil
    end
  end
  context "valid personal info and invalid card" do
    before :each do
      customer = double('customer', succesful?: false, error_message: "Invalid Card")
      expect(StripeWrapper::Customer).to receive(:create) { customer }
      @signup = SignUp.new(user: Fabricate.attributes_for(:user), stripeToken: '123')
      @signup.register
    end
    it "should set the success? variable to be false" do
      expect(@signup.success?).to be_falsey
    end
    it "to set the errors variable" do
      expect(@signup.error).to eq("Invalid Card")
    end

    it "should not create the user" do
      expect(User.count).to eq(0)
    end

    it "should not send an email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
  context "invalid attributes" do
    before(:each) do
      @signup = SignUp.new(user: Fabricate.attributes_for(:user, email: nil), stripeToken: '123')
      @signup.register
    end
    it "should sets the @signup to false" do
      expect(@signup.success?).to be_falsey
    end

    it "to set the errors variable" do
      expect(@signup.error).to eq("Invalid user details")
    end
    it "should not create the user" do
      expect(User.count).to eq(0)
    end

    it "should not send an email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "does not charge the card" do
      expect(StripeWrapper::Customer).to_not receive(:create)
    end
  end
end