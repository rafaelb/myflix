require 'rails_helper'

describe ReviewsController do
  let(:video) { Fabricate(:video) }
  context "logged in" do
    before(:each) do
      session[:user_id] = Fabricate(:user).id
    end

    describe 'POST #create' do
      context "valid attributes" do
        before(:each) do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it "creates a Review" do
          expect(Review.count).to eq(1)
        end

        it "creates a Review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "should associate the review to the user" do
          user = User.find(session[:user_id])
          expect(user.reviews.count).to eq(1)
        end

        it "should redirect to video page" do
          expect(response).to redirect_to video
        end

        it "it should flash notice" do
          expect(flash[:notice]).to eq("Your review was created")
        end
      end

      context "invalid attributes" do
        before(:each) do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review, content: nil)
        end

        it "does not creates a Review" do
          expect(Review.count).to eq(0)
        end

        it "should render videos/show template" do
          expect(response).to render_template 'videos/show'
        end
      end
    end
  end



  context 'guest' do
    describe 'POST #create' do
      context "valid attributes" do
        before(:each) do
          post :create, video_id: video.id, review: Fabricate.attributes_for(:review)
        end

        it "does not creates a Review" do
          expect(Review.count).to eq(0)
        end

        it 'redirects to root_path' do
          expect(response).to redirect_to login_path
        end
      end
    end
  end
end
