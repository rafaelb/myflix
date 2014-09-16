require 'rails_helper'

describe ForgotPasswordsController do
  describe 'GET#new' do
    it_behaves_like "require guest" do
      let(:action) { get :new }
    end
  end

  describe 'GET#post' do
    it_behaves_like "require guest" do
      let(:action) { post :create, email: 'example@example.com' }
    end

    context "with existing email" do
      before (:each) do
        @user = Fabricate(:user)
        post :create, email: @user.email
      end
      it "redirects to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "sends an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([@user.email])
      end
    end
    context "with non-existing email" do
      before :each do
        post :create, email: 'rerer@fdsfsdf.cdf'
      end
      it "redirects to the forgot password page" do
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("Invalid email!!!")
      end
    end
    context "with blank input" do
      before :each do
        post :create, email: ''
      end
      it "redirects to the forgot password page" do
        expect(response).to redirect_to(forgot_password_path)
      end

      it "shows an error message" do
        expect(flash[:error]).to eq("Can't be blank!!!")
      end
    end
  end

end