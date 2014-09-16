require 'rails_helper'

feature "Resetting Password" do
  background do
    @user1 = Fabricate(:user, password: 'oldpassword')
    clear_emails
  end

  scenario "user succesfully resets password" do
    visit login_path
    click_link "Forgot Password?"
    fill_in "Email Address", with: @user1.email
    click_button "Send Email"
    open_email(@user1.email)
    current_email.click_link "Reset My Password"
    fill_in "New Password", with: 'newpassword'
    click_button "Reset Password"
    expect(page).to have_content "Password Reset!!!"
    fill_in "Email Address", with: @user1.email
    fill_in "Password", with: 'newpassword'
    click_button 'Sign In'
    expect(page).to have_content @user1.full_name

  end
end