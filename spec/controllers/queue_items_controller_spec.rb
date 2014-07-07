require 'rails_helper'
require 'pry'
describe QueueItemsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
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
  end
end