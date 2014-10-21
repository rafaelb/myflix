require 'rails_helper'

feature "User Registering" do
  background do
    visit register_path
  end

  scenario "valid user and valid credit card", :js, :vcr  do
    valid_user
    valid_card
    expect(page).to have_content "User Registered!"
  end


  scenario "valid user and invalid credit card", :js, :vcr  do
    valid_user
    invalid_card
    expect(page).to have_content "Your card number is incorrect."
  end

  scenario "valid user and declined credit card", :js, :vcr  do
    valid_user
    declined_card
    expect(page).to have_content "Your card was declined."
  end

  scenario "invalid user and valid credit card", :js, :vcr  do
    invalid_user
    valid_card
    expect(page).to have_content "Invalid user details"
  end

  scenario "invalid user and invalid credit card", :js, :vcr  do
    invalid_user
    invalid_card
    expect(page).to have_content "Your card number is incorrect."
  end

  scenario "invalid user and declined credit card", :js, :vcr  do
    invalid_user
    declined_card
    expect(page).to have_content "Invalid user details"
  end
end
def valid_user
  user_details("ttt@ttt.com", 'ttt', 'Ttt')
end

def invalid_user
  user_details(nil, 'ttt', 'Ttt')
end

def valid_card
  pay_with_credit_card(4242424242424242)
end

def invalid_card
  pay_with_credit_card(1234567890123456)
end
def declined_card
  pay_with_credit_card(4000000000000002)
end
def user_details(email, password, fullname)
  fill_in "Email Address", with: email
  fill_in "Password", with: password
  fill_in "Full name", with: fullname
end

def pay_with_credit_card(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select "3 - March", from: 'date_month'
  select "2015", from: 'date_year'
  click_button "Sign Up"
end