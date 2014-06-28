require 'rails_helper'

describe SessionsController do
  context "logged in" do
    before :each do
      session[:user_id] = Fabricate(:user).id
    end

    describe "GET #new" do
      before :each do
        get :new
      end
      it { expect(response).to redirect_to(home_path) }
    end

    describe "POST #create" do
      before :each do
        post :create
      end
      it { expect(response).to redirect_to(home_path) }
    end

    describe  "POST #destroy" do
      before :each do
        post :destroy
      end
      it { expect(response).to redirect_to(root_path) }
      it { expect(session[:user_id]).to be_nil }
      it { expect(flash[:notice]).to_not be_empty }
    end
  end

  context "guest" do

    describe "GET #new" do
      before :each do
        get :new
      end
      it { expect(response).to render_template :new }
    end

    describe "POST #create" do
      let(:user) { Fabricate(:user)}
      context "valid attributes" do
        before :each do
          post :create, email: user.email, password: user.password
        end
        it { expect(response).to redirect_to home_path }
        it { expect(session[:user_id]).to eq(user.id) }
        it { expect(flash[:notice]).to_not be_empty }
      end
      context "invalid attributes" do
        before :each do
          post :create, email: user.email, password: user.password + "sdfjklhsdkjfhasdjklfhasdjklfh"
        end
        it { expect(response).to render_template :new }
        it { expect(session[:user_id]).to be_nil }
        it { expect(flash[:error]).to_not be_empty }
      end
    end

  end
end