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

    describe "GET #show" do
      it "sets @user" do
        user = Fabricate(:user)
        get :show, id: user.id
        expect(assigns(:user)).to eq user
      end
    end

    describe "GET #new_with_invitation_token" do
      it "should redirect to home path" do
        get :new_with_invitation_token, token: 'asdasjkdhasjkdh'
        expect(response).to redirect_to home_path
      end
    end
  end

  context "guest" do
    describe "GET #new" do
      before :each do
        get :new
      end
      it "should render new template" do
        expect(response).to render_template :new
      end
      it "should set the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      it "should set @referer_id to be nil" do
        expect(assigns(:referer_id)).to be_nil
      end
    end

    describe "GET #new_with_invitation_token" do
      before :each do
        @referer = Fabricate(:user)
      end

      context "User already exists" do
        before :each do
          @user = Fabricate(:user)
          @invite = Invite.create(inviter: @referer, recipient_name: @user.full_name, recipient_email: @user.email, message: 'dasjkldhask')
          get :new_with_invitation_token, token: @invite.token
        end
        it "should redirect to login path" do
          expect(response).to redirect_to login_path
        end
        it "should flash notice of already registered" do
          expect(flash[:notice]).to eq("You are already registered! Login below!")
        end
      end

      context "User doesn't exist" do
        before :each do
          @invite = Invite.create(inviter: @referer, recipient_name: "New User", recipient_email: "new@user.com", message: "llafhsdkajfhasdjklfhasdjklfhasdjklfhasdjklfhasdjklhlkasfdfhasdkljh")
          get :new_with_invitation_token, token: @invite.token
        end

        it "should set the @user variable" do
          expect(assigns(:user)).to be_instance_of(User)
        end

        it "should set the user's email address" do
          expect(assigns(:user).email).to eq "new@user.com"
        end

        it "should set the user's full name" do
          expect(assigns(:user).full_name).to eq "New User"
        end

        it "renders the new template" do
          expect(response).to render_template :new
        end
      end
    end

    describe "POST #create" do
      context "valid attributes" do
        before(:each) do
          result = double(:register_result, success?: true)
          SignUp.any_instance.should_receive(:register).and_return(result)
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
        end
        it "should redirect to root path" do
          expect(response).to redirect_to root_path
        end

        it "should flash noitce of User Registered" do
          expect(flash[:notice]).to eq("User Registered!")
        end

      end

      context "valid personal info and invalid card" do
        before :each do
          result = double(:register_result, success?: false, error: "Invalid Card", user: Fabricate.attributes_for(:user))
          SignUp.any_instance.should_receive(:register).and_return(result)
          post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
        end
        it "should render the new template" do
          expect(response).to render_template :new
        end
        it "should set the @user variable" do
          expect(assigns(:user)).to_not be_nil
        end

        it "should set the flash[:error] message" do
          expect(flash[:error]).to be_present
        end
      end
      context "invalid attributes" do
        before(:each) do
          result = double(:register_result, success?: false, error: "Invalid user details", user: Fabricate.attributes_for(:user, email:nil))
          SignUp.any_instance.should_receive(:register).and_return(result)
          post :create, user: Fabricate.attributes_for(:user, email: nil), stripeToken: '123'
        end
        it "should render the new template" do
          expect(response).to render_template :new
        end
        it "should set the @user variable" do
          expect(assigns(:user)).to_not be_nil
        end

        it "should set the flash[:error] message" do
          expect(flash[:error]).to be_present
        end

      end
    end

    describe "GET #show" do
      it_behaves_like "requires sign in" do
        let(:action) { get :show, id: 1 }
      end
      it "redirects to the login_path if guest" do
        get :show, id: 1
        expect(response).to redirect_to(login_path)
      end
    end
  end
end