require 'rails_helper'

feature "Signing in" do
  background do
    @user1 = Fabricate(:user)
  end

  scenario "with valid e-mail and password" do
    sign_in_user(@user1)
    expect(page).to have_content @user1.full_name
  end

end