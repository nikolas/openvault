require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

Capybara.asset_host = 'http://localhost:3000'

describe 'Digitization Requests Tab for User Profile Page' do
  REQ_TAB = "Digitization Requests"
  
  before(:each) do
    @user = create(:user, :password => 'password', :password_confirmation => 'password')
    submit_login_form({email: @user.email, password: @user.password})
    @video = Video.new
    Fixtures.cwd("#{fixture_path}/pbcore")
    @video.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
    @video.save
    @artifact = Artifact.create(pid: @video.pid)
    @artifact.request_digitization(@user)
    @sponsorship = @user.sponsorships.first
    @sponsorship.save
  end
  
  it "hides requests if not logged in" do
    click_link "Log Out"
    visit "/user/#{@user.username}"
    expect(page).not_to have_content(REQ_TAB)
  end

  it "shows artifacts user have requested", halp: true  do
    visit user_root_path
    click_link(REQ_TAB)
    expect(page).to have_content(@artifact.title)
  end

  it "shows digitization status of 'requested' when user has requested artifact" do
    visit user_root_path
    click_link(REQ_TAB)
    within("tr#sponsorship-#{@sponsorship.id} .state") do
      expect(page).to have_content("requested")
    end
  end

  it "shows user status of 'following' when user has requested artifact" do
    visit user_root_path
    click_link(REQ_TAB)
    within("tr#sponsorship-#{@sponsorship.id} .status") do
      expect(page).to have_content("Following")
    end
  end

  it "shows option to 'unfollow' requested artifact" do
    visit user_root_path
    click_link(REQ_TAB)
    within("tr#sponsorship-#{@sponsorship.id} .actions") do
      expect(page).to have_content("Unfollow")
    end
  end

  it "shows digitization status of 'digitizing' when artifact is digitizing" do
    @artifact.approve_digitization(@user)
    visit user_root_path
    click_link(REQ_TAB)
    expect(find("tr#sponsorship-#{@sponsorship.id} .state")).to have_content('digitizing')
  end

  it "shows digitization status of 'denied' when digitization has been denied" do
    @artifact.block(@user)
    visit user_root_path
    click_link(REQ_TAB)
    expect(find("tr#sponsorship-#{@sponsorship.id} .state")).to have_content('blocked')
  end

  it "shows user status of 'Confirmed/Sponsor' when user is a confirmed sponsor" do
    @sponsorship.confirm!
    @sponsorship.save
    visit user_root_path
    click_link(REQ_TAB)
    expect(find("tr#sponsorship-#{@sponsorship.id} .status")).to have_content('Confirmed/Sponsor')
  end

  it "doesn't show action 'Unfollow' when user is a confirmed sponsor and artifact is digitizing" do
    @sponsorship.confirm!
    @artifact.approve_digitization(@user)
    visit user_root_path
    click_link(REQ_TAB)
    within("#sponsorship-#{@sponsorship.id} .actions") do
      expect(page).to have_content("")
    end
  end

  it "clicking 'Unfollow' removes artifact from dashboard" do
    visit user_root_path
    click_link(REQ_TAB)
    within("tr#sponsorship-#{@sponsorship.id} .actions") do
      click_button("Unfollow")
    end
    visit user_root_path
    click_link(REQ_TAB)
    expect(page).not_to have_content(@artifact.title)
  end

  it "shows digitization status of 'published' when digitization has been published" do
    @sponsorship.confirm!
    @artifact.approve_digitization(@user)
    @artifact.publish(@user)
    visit user_root_path
    click_link(REQ_TAB)
    within("tr#sponsorship-#{@sponsorship.id} .state") do
      expect(page).to have_content("published")
    end
  end
end
