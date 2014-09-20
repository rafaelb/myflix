require 'rails_helper'

feature "Adding Video" do
  background do
    Category.create(name: "Test category")
  end
  scenario "admin adds video" do
    sign_in_admin
    expect(page).to have_content "Add Video"
    click_link "Add Video"
    expect(page).to have_content "Add a New Video"
    fill_in "Title", with: "Test title"
    select "Test category", from: "Category"
    fill_in "Description", with: "Test description"
    attach_file 'Large cover', "spec/support/uploads/monk_large.jpg"
    attach_file 'Small cover', "spec/support/uploads/monk.jpg"
    fill_in "Video url", with: "http://www.test.com"
    click_button "Add Video"
    expect(page).to have_content "Video Saved"

    sign_out
    sign_in_user

    visit video_path(Video.first)

    expect(page).to have_selector("img[src='uploads/video/large_cover/1/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.test.com']")

  end
end