require 'rails_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders reset password page if token is valid" do
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    it "sets @token if token is valid" do
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: '12345'
      expect(assigns(:token)).to eq '12345'
    end
    it "redirects to the expired token page if the token is not valid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end
  end

  describe  "POST create" do
    context "with valid token" do
      before :each do
        @user = Fabricate(:user, password: 'oldpassword')
        @user.update_column(:token, '12345')
        post :create, password: 'test', token: '12345'
      end
      it "updates the user's password" do
        expect(@user.reload.authenticate('test')).to be_truthy
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to login_path
      end
      it "sets the flash success message" do
        expect(flash[:success]).to eq "Password Reset!!!"
      end
      it "regenerates the user's token" do
        expect(@user.reload.token).to_not eq '12345'
      end
    end
    context "with invalid token" do
      it "redirects to expired token path" do
        post :create, password: 'test', token: '12345'
        expect(response).to redirect_to expired_token_path
      end
    end

  end
end