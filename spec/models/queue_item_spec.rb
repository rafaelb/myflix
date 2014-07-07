require 'rails_helper'

describe QueueItem do

  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_presence_of(:position) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:video)}
  it { should validate_uniqueness_of(:position).scoped_to(:user_id) }
  it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq video.title
    end
  end

  describe "#category_name" do
    it "returns the name of the associated video's category" do
      cat = Fabricate(:category)
      video = Fabricate(:video, category: cat)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq cat.name
    end
  end

  describe "#category" do
    it "returns the category of the associated video" do
      cat = Fabricate(:category)
      video = Fabricate(:video, category: cat)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq cat
    end
  end

  describe "#rating" do
    it "returns the user's review of the associated video when review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user)
      queue_item = Fabricate(:queue_item, video: video, user:user)
      expect(queue_item.rating).to eq review.rating
    end

    it "return nil when review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video: video, user:user)
      expect(queue_item.rating).to eq nil
    end
  end
end