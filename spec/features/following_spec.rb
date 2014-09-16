require 'rails_helper'

feature 'Following other users' do
  background do
    @user1 = Fabricate(:user)
    @user2 = Fabricate(:user)
    sign_in_user(@user1)
  end

end