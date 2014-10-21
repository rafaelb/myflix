require 'rails_helper'

describe Category do
  it { should validate_presence_of (:name) }
  it { should validate_uniqueness_of (:name) }
  it { should have_many(:videos).order(created_at: :desc) }

  describe "#recent_videos" do
    it "return an empty array if there is no videos" do
      cat1 = Category.create(name: 'cat1')
      expect(cat1.recent_videos).to eq []
    end
    it "returns the videos in reverse chronological order by created_at" do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.day.ago)
      vid2 = Video.create(title: 'vid2', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.month.ago)
      expect(cat1.recent_videos).to eq([vid1,vid2])
    end

    it "return all videos if there are less than 6 videos" do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)
      vid2 = Video.create(title: 'vid2', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)
      expect(cat1.recent_videos.count).to eq(2)
    end
    it "should return 6 videos if there is more than 6" do
      cat1 = Category.create(name: 'cat1')
      7.times{ Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1) }
      expect(cat1.recent_videos.count).to eq(6)
    end
    it "should return the 6 most recent videos" do
      cat1 = Category.create(name: 'cat1')
      6.times{ Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)}
      vid2 = Video.create(title: 'vid2', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.day.ago)
      expect(cat1.recent_videos).not_to eq(vid2)
    end

  end
end