require 'rails_helper'

describe InvitesController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
    context "signed in user" do
      before :each do
        set_current_user
        get :new
      end
      it "allocates @invite variable" do
        expect(assigns(:invite)).to be_instance_of(Invite)
      end
    it "renders new template" do
      expect(response).to render_template(:new)
    end
      end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context 'with valid attributes' do
      before :each do
        set_current_user
        post :create, invite: {recipient_name: "John Smith", recipient_email: "john@smith.com", message: "Join this site"}
      end


      it "redirect to the invite path" do
        expect(response).to redirect_to(invite_path)
      end

      it "should create the invite" do
        expect(Invite.count).to eq(1)
      end
      it "sends and email to the correct e-mail address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@smith.com"])
      end

      it "sets the flash success" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      before :each do
        set_current_user
        post :create, invite: {recipient_name: "John Smith", message: "Join this site"}
      end
      it "should not create invite" do
        expect(Invite.count).to eq(0)
      end
      it "should render the :new template" do
        expect(response).to render_template :new
      end
      it "set the flash error" do
        expect(flash[:error]).to be_present
      end
      it "sets the @invite variable" do
        expect(assigns(:invite)).to be_instance_of(Invite)
      end
    end

  end
end