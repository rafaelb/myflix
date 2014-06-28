require 'rails_helper'

describe UsersController do
  context "logged in user" do
    before :each do
      session[:user_id] = Fabricate(:user).id
    end

    describe "GET #new" do
      it "should redirect to home path" do
        get :new
        expect(response).to redirect_to home_path
      end
    end

    describe "POST #create" do
      it "should redirect to home path" do
        post :create
        expect(response).to redirect_to home_path
      end
    end
  end

  context "guest" do
    describe "GET #new" do
      before :each do
        get :new
      end
      it "should redirect to root path" do
        expect(response).to render_template :new
      end
      it "should set the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    describe "POST #create" do
      context "valid attributes" do
        before(:each) do
          post :create, user: Fabricate.attributes_for(:user)
        end
        it "should redirect to root path" do
          expect(response).to redirect_to root_path
        end

        it "should flash noitce of User Registered" do
          expect(flash[:notice]).to eq("User Registered!")
        end

        it "should create the user" do
          expect(User.count).to eq(1)
        end
      end

      context "invalid attributes" do
        before(:each) do

          post :create, user: Fabricate.attributes_for(:user, email: nil)
        end
        it "should render the new template" do
          expect(response).to render_template :new
        end
        it "should set the @user variable" do
          expect(assigns(:user)).to be_instance_of(User)
        end

        it "should not create the user" do
          expect(User.count).to eq(0)
        end
      end
    end
  end
end