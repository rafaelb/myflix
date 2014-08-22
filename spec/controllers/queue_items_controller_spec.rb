require 'rails_helper'
require 'pry'
describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  #let(:review) { Fabricate(:review, user: user, video:video)}
  let(:queue_item1) { Fabricate(:queue_item, user: user, position: 4) }
  let(:queue_item2) { Fabricate(:queue_item, user: user, position: 5) }

  context 'logged in' do
    before :each do
      session[:user_id] = user.id
    end
    describe 'GET #index' do
      before :each do
        get :index
      end
      it "assigns the user's queue items to @queue_items" do
        expect(assigns(:queue_items)).to eq [queue_item1, queue_item2]
      end
    end
    describe 'POST #create' do
      before :each do
        post :create, video_id: video.id
      end
      it "should redirect to my queue page" do
        expect(response).to redirect_to my_queue_path
      end
      it "creates a queue item" do
        expect(QueueItem.count).to eq(1)
      end
      it "creates a queue item that is associated with the video" do
        expect(QueueItem.last.video).to eq(video)
      end
      it "creates a queue item that is associated with the signed in user" do
        expect(QueueItem.last.user).to eq(user)
      end

      it "puts the video as the last one in the queue" do
        video2 = Fabricate(:video)
        post :create, video_id: video2.id
        qitem = QueueItem.where(video_id: video2.id, user_id: user.id).first
        expect(qitem.position).to eq 2
      end
      it "doesn't add video to the queue if video already is added" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end
    end
    describe 'DELETE destroy' do
      it "redirects to my queue page" do
        delete :destroy, id: queue_item1.id
        expect(response).to redirect_to my_queue_path
      end
      it "deletes the queue item" do
        delete :destroy, id: queue_item1.id
        expect(QueueItem.count).to eq(0)
      end
      it "does not delete the queue item if it is not in the current user's queue" do
        user2 = Fabricate(:user)
        queue_item3 = Fabricate(:queue_item, user: user2)
        delete :destroy, id: queue_item3.id
        expect(QueueItem.count).to eq(1)
      end
      it "normalizes the remaining queue items" do
        qitem1 = Fabricate(:queue_item, user: user, position: 1)
        qitem2 = Fabricate(:queue_item, user: user, position: 2)
        qitem3 = Fabricate(:queue_item, user: user, position: 3)
        delete :destroy, id: qitem2.id
        expect(user.queue_items.map(&:position)).to eq([1,2])
      end

      describe 'POST update_queue' do
        context "with valid inputs" do
          before :each do
            @qitem1 = Fabricate(:queue_item, user: user, position: 1, video: video)
            @qitem2 = Fabricate(:queue_item, user: user, position: 2)
            @review = Fabricate(:review, user: user, video: video, rating: 1)
          end
          it "redirects to the my queue page" do
            post :update_queue, queue_items: [{id: @qitem1.id, position: 2}, {id: @qitem2.id, position: 1}]
            expect(response).to redirect_to my_queue_path
          end
          it "reorders the queue items" do
            post :update_queue, queue_items: [{id: @qitem1.id, position: 2}, {id: @qitem2.id, position: 1}]
            expect(user.queue_items).to eq([@qitem2, @qitem1])
          end
          it "normalises the positions numbers" do
            post :update_queue, queue_items: [{id: @qitem1.id, position: 3}, {id: @qitem2.id, position: 2}]
            expect(user.queue_items.map(&:position)).to eq([1,2])
          end
          it "updates the rating of the review associated with the queue item" do
            post :update_queue, queue_items: [{id: @qitem1.id, position: 1, rating: 2}, {id: @qitem2.id, position: 2}]
            expect(@review.reload.rating).to eq 2
          end

          it "creates a new review if there is no review" do
            post :update_queue, queue_items: [{id: @qitem1.id, position: 1}, {id: @qitem2.id, position: 2, rating: 2}]
            expect(Review.last.rating).to eq 2
          end
        end
        context "with invalid inputs" do
          before :each do
            @qitem1 = Fabricate(:queue_item, user: user, position: 1)
            @qitem2 = Fabricate(:queue_item, user: user, position: 2)
            post :update_queue, queue_items: [{id: @qitem1.id, position: 3.4}, {id: @qitem2.id, position: 2}]

          end
          it "redirects to the my queue page" do
            expect(response).to redirect_to my_queue_path
          end

          it "doesn't change any of the user's queue items" do
            expect(@qitem1.reload.position).to eq(1)
          end
          it "sets the flash error message" do
            expect(flash[:error]).to be_present
          end
        end
        context "with queue items that do not belong to the current user" do
          before :each do
            user2 = Fabricate(:user)
            @qitem1 = Fabricate(:queue_item, user: user2, position: 1)
            @qitem2 = Fabricate(:queue_item, user: user, position: 2)
            post :update_queue, queue_items: [{id: @qitem1.id, position: 3}, {id: @qitem2.id, position: 2}]
          end
          it "does not change the queue items" do
            expect(@qitem1.reload.position).to eq(1)
          end
        end
      end

    end
  end

  context 'not logged in' do
    describe 'GET #index' do
      before :each do
        get :index
      end
      it "redirects to the login_path" do
        expect(response).to redirect_to(login_path)
      end
    end
    describe 'POST #create' do
      before :each do
        post :create
      end

      it "redirects to the login_path" do
        expect(response).to redirect_to(login_path)
      end
    end

    describe 'DELETE destroy' do
      before :each do
        delete :destroy, id: queue_item1.id
      end
      it "redirects to the login_path" do
        expect(response).to redirect_to(login_path)
      end
    end
    describe 'POST update_queue' do

    end
  end
end