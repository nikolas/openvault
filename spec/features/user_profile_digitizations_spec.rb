require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'Digitization Requests Tab for User Profile Page' do
	 before(:each) do
    @user = create(:user, :password => 'password', :password_confirmation => 'password')
    submit_login_form({email: @user.email, password: @user.password})
    @ov_asset = OpenvaultAsset.new(:pid => 'test:1234')
    @ov_asset.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
    @ov_asset.save
    @artifact = Artifact.create(:pid => @ov_asset.pid)
  end

  it "shows artifacts they have requested", halp: true  do
    @artifact.request_digitization(@user)
    visit user_root_path
    save_and_open_page
    click_link("Digitization Requests")
    expect(page).to have_content(@artifact.title)
  end

  it "shows digitization status of 'requested' when user has requested artifact", halp: true do
    @artifact.request_digitization(@user)
    @sponsorship = @user.sponsorships.first
    @sponsorship.save
    visit user_root_path
    click_link("Digitization Requests")
    save_and_open_page
    within("tr#sponsorship-#{@sponsorship.id} .state") do
      expect(page).to have_content("requested")
    end
  end

  # it "shows user status of 'following' when user has requested artifact", halp: true do
  #   @artifact.request_digitization(@user)
  #   @artifact.save
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   within("tr#sponsorship-#{@sponsorship.id} .status") do
  #     expect(page).to have_content("Following")
  #   end
  # end

  # it "shows option to 'unfollow' requested artifact" do
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   within("tr#sponsorship-#{@sponsorship.id} .actions") do
  #     expect(page).to have_content("Unfollow")
  #   end
  # end

  # it "shows digitization status of 'digitizing' when artifact is digitizing" do
  #   @artifact.approve_digitization(@user)
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   expect(find("tr#sponsorship-#{@sponsorship.id} .state")).to have_content('digitizing')
  # end

  # it "shows digitization status of 'denied' when digitization has been denied", wip: true do
  #   @artifact.block(@user)
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   expect(find("tr#sponsorship-#{@sponsorship.id} .state")).to have_content('blocked')
  # end

  # it "shows user status of 'Confirmed/Sponsor' when user is a confirmed sponsor" do
  #   @sponsorship.confirm!
  #   @sponsorship.save
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   expect(find("tr#sponsorship-#{@sponsorship.id} .status")).to have_content('Confirmed/Sponsor')
  # end

  # it "doesn't show action 'Unfollow' when user is a confirmed sponsor and artifact is digitizing" do
  #   @sponsorship.confirm!
  #   @artifact.approve_digitization(@user)
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   within("#sponsorship-#{@sponsorship.id} .actions") do
  #     expect(page).to have_content("")
  #   end
  # end

  # it "clicking 'Unfollow' removes artifact from dashboard" do
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   within("tr#sponsorship-#{@sponsorship.id} .actions") do
  #     click_link("Unfollow")
  #   end
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   expect(page).not_to have_content(@artifact.title)
  # end

  # it "shows digitization status of 'published' when digitization has been published" do
  #   @artifact.approve_digitization(@user)
  #   @artifact.publish(@user)
  #   visit user_root_path
  #   click_link("Digitization Requests")
  #   sleep(5)
  #   within("tr#sponsorship-#{@sponsorship.id} .state") do
  #     expect(page).to have_content("published")
  #   end
  # end
end
