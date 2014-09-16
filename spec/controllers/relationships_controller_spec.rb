require 'rails_helper'

describe RelationshipsController do
  let(:user2) { Fabricate(:user) }
  before :each do
    set_current_user
  end
  describe "GET#index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST#create" do

    it_behaves_like "requires sign in" do
      let(:action) { post :create, user_id: user2.id }
    end

    before :each do
      post :create, user_id: user2.id
    end
    it "should redirect to people page" do
      expect(response).to redirect_to people_path
    end
    it "creates a relationship" do
      expect(current_user.relationships.count).to eq(1)
    end
    it "creates a relationship that is associated with the current user" do
      expect(current_user.following?(user2)).to be_truthy
    end
    it "creates a relationship that is associated with the followed user" do
      expect(user2.followed_by?(current_user)).to be_truthy
    end
  end

  describe "DELETE#destroy" do

    before :each do
      set_current_user
      @relation = current_user.follow(user2)
      delete :destroy, id: @relation.id
    end

    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: @relation.id }
    end


    it "should redirect to people page" do
      expect(response).to redirect_to people_path
    end
    it "delete a relationship that is associated with the current user" do
      expect(current_user.following?(user2)).to be_falsey
    end
    it "delete a relationship that is associated with the followed user" do
      expect(user2.followed_by?(current_user)).to be_falsey
    end

    it "delete a relationship" do
      expect(current_user.relationships.count).to eq(0)
    end


  end
end