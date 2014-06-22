require 'rails_helper'

describe Video  do

  it { should belong_to (:category)}
  it { should validate_presence_of(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe "search_by title" do

    it "returns an empty array if there is no match" do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)
      expect(Video.search_by_title('sdfsd')).to eq([])

    end

    it "returns an array of one video for an exact match" do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)
      expect(Video.search_by_title('vid1')).to eq([vid1])

    end

    it "returns an array of one video for a partial match" do

      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1)
      expect(Video.search_by_title('vi')).to eq([vid1])
    end

    it "returns an array of all matches ordered by created_at"do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid2', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.day.ago)
      vid2 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.year.ago)
      expect(Video.search_by_title('vi')).to eq([vid2,vid1])
    end

    it "returns an empty array when given an empty string" do
      cat1 = Category.create(name: 'cat1')
      vid1 = Video.create(title: 'vid2', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.day.ago)
      vid2 = Video.create(title: 'vid1', description: 'fasdlkfjsdklafj asdfjk sda', category: cat1, created_at: 1.year.ago)
      expect(Video.search_by_title('')).to eq([])
    end
  end


end