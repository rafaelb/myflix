require 'rails_helper'

describe Admin::VideosController do
  describe "GET #new" do
    context "not admin" do
      it_behaves_like "require admin" do
        let(:action) { get :new }
      end
    end
    context "logged in as admin" do
      before(:each) do
        set_admin_user
        get :new
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "sets @video to new Video" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end

  end
  describe  "POST #create" do
    context "not admin" do
      it_behaves_like "require admin" do
        let(:action) { post :create }
      end
    end
    context "with valid inputs" do
      before(:each) do
        set_admin_user
        post :create, video: Fabricate.attributes_for(:video)
      end
      it "creates a video" do
        expect(Video.count).to eq 1
      end
      it "redirects to the add video page" do
        expect(response).to redirect_to new_admin_video_path
      end
      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      before(:each) do
        set_admin_user
        post :create, video: Fabricate.attributes_for(:video, title: nil)
      end
      it "does not create a video" do
        expect(Video.count).to eq 0
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
      it "sets the flash error message" do
        expect(flash[:error]).to be_present
      end
      it "sets the @video variable" do
        expect(assigns(:video)).to be_instance_of(Video)
      end
    end
  end
end