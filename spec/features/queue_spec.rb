require 'rails_helper'

feature "Queue with valid user and video" do
  background do
    @category = Fabricate(:category)
    @video1 = Fabricate(:video, category: @category)
    @video2 = Fabricate(:video, category: @category)
    @video3 = Fabricate(:video, category: @category)
    @user1 = Fabricate(:user)
    sign_in_user(@user1)
    visit root_path
    #click_link("#video-#{@video1.id}")
    find("a[href='/videos/#{@video1.id}']").click
  end

  scenario "it shows the video page" do
    expect(page).to have_content @video1.title
  end

  scenario "it adds to the queue" do
    click_link "+ My Queue"
    expect(page).to have_content 'List Order'
    expect(page).to have_content @video1.title
  end

  scenario "it doesn't have the + My Queue button once in the queue" do
    click_link "+ My Queue"
    click_link @video1.title
    expect(page).to_not have_content "+ My Queue"
  end

  scenario "changing queue order" do
    click_link "+ My Queue"
    click_link @video1.title
    add_video_to_queue(@video2)
    add_video_to_queue(@video3)

    set_video_position(@video1, 3)
    set_video_position(@video2, 1)
    set_video_position(@video3, 2)
    click_button "Update Instant Queue"
    expect_video_position(@video2,1)
    expect_video_position(@video3,2)
    expect_video_position(@video1,3)

  end

  def add_video_to_queue(video)
    visit root_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath,"//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq "#{position}"
  end
end