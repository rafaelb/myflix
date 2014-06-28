require 'rails_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  context 'not logged in' do
    describe 'GET #show' do

      it "redirects to the login_path if guest" do
        get :show, id: video
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'POST #search' do
      it "redirects to the login path if guest" do
        post :search
        expect(response).to redirect_to(login_path)
      end
    end
  end
  context 'logged in' do
    before :each do
      session[:user_id] = Fabricate(:user).id
    end
    describe 'GET #show' do
      before :each do
        get :show, id: video.id
      end
      it "assigns the requested video to @video" do
        expect(assigns(:video)).to eq video
      end

      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end

    describe 'POST #search' do
      let(:a) { Fabricate(:video, title: 'a') }
      let(:aa) { Fabricate(:video, title: 'aa') }
      let(:b) { Fabricate(:video, title: 'b') }

      it "should assign all videos that contain the requested string to @videos" do
        post :search, search_term: 'a'
        expect(assigns(:videos)).to include(a, aa)
      end

      it "should not assign video that don't contain the requested string" do
        post :search, search_term: 'a'
        expect(assigns(:videos)).to_not include(b)
      end

      it "renders the :search template" do
        post :search, search_term: 'a'
        expect(response).to render_template :search
      end
    end
  end
end