require 'rails_helper'

describe Relationship do
  it { should belong_to(:follower).class_name('User') }
  it { should belong_to(:followed).class_name("User") }
  it { should validate_presence_of(:follower)}
  it { should validate_presence_of(:followed)}
end