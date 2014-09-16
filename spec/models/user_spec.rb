require 'rails_helper'

describe User do
  it { should validate_presence_of (:email)}
  it { should validate_presence_of (:full_name)}
  it { should validate_uniqueness_of (:email) }
  it { should have_secure_password }
  it { should have_many (:reviews) }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:relationships).with_foreign_key('follower_id') }
  it { should have_many(:followed_users).through(:relationships).source(:followed) }
  it { should have_many(:reverse_relationships).with_foreign_key('followed_id').class_name('Relationship') }
  it { should have_many(:followers).through(:reverse_relationships).source(:follower) }
  it { should have_many(:invites).with_foreign_key('inviter_id')}

  it "generates a random token when the user is created" do
    user = Fabricate(:user)
    expect(user.token).to be_present
  end

  describe "#queued_video?" do
    it "returns true when the user queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video:video)
      expect(user.queued_video?(video)).to be_truthy
    end
    it "returns false if the user did not queue the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to_not be_truthy
    end
  end
end