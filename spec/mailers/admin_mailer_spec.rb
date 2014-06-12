require "spec_helper"
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe AdminMailer do
	before do
	  @user = create(:user)
    @ov_asset = OpenvaultAsset.new(:pid => 'test:1234')
    @ov_asset.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
    @ov_asset.save
  	@artifact = Artifact.create(:pid => @ov_asset.pid)
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
