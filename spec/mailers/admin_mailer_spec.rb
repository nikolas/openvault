require "spec_helper"
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe AdminMailer do
  before do
    @user = create(:user)
    @video = Video.new
    Fixtures.cwd("#{fixture_path}/pbcore")
    @video.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
    @video.save
    @artifact = Artifact.create(pid: @video.pid)
    @artifact.request!(@user)
    @artifact.save
  end

  it "should email an admin when a request is made" do
  	ActionMailer::Base.deliveries.last.to.should == ["openvault@wgbh.org"]
  end

  it "should email an admin when a request is withdrawn" do
  	@artifact.withdraw_request(@user)
  	ActionMailer::Base.deliveries.last.subject.should == "Your request for digitization has been withdrawn"
  end

end
