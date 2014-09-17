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
end