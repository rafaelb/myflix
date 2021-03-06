require 'rails_helper'

describe Invite do
  it { should belong_to(:inviter).class_name('User')}
  it { should validate_presence_of(:inviter) }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
end