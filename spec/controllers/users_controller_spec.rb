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

        it "should send out the welcome email" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end
        it "sends email to the right recepient" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq([User.last.email])

        end
        it "has the right content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body ).to include("Hello #{User.last.full_name}")
        end
      end

      context "valid referer" do
        before :each do
          @referer = Fabricate(:user)
          @invite = Invite.create(inviter: @referer, recipient_name: "New User", recipient_email: "new@user.com", message: 'ffdsjkfhsdjkfh')
          post :create, user: Fabricate.attributes_for(:user, email: "new@user.com")
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

        it "should not send an email" do
          expect(ActionMailer::Base.deliveries).to be_empty
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