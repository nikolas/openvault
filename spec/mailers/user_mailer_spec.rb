require "spec_helper"
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe UserMailer do

  # TODO: Tests between here and </TODO> are actually testing behavior of Artifact model,
  #  specifically Artifact#save. The tests are testing the side effect of mail being sent.
  #  A more appropriate way to test this is is move them to spec/models/artifact, and test
  #  that the appropriate method on the mailers got called. For instance, if you want to ensure
  #  that Usermailer.request_withdrawn_email(user, artifact).deliver get's called as a result
  #  of some behavior of Artifact, then testing might look like this...
  #   
  #    allow(UserMailer).to receive(:request_withdrawn_email).with(@user, @artifact).and_return(double)
  #    expect(UserMailer.request_withdrawn).to receive(:deliver)
  #
  #   ... or something like that. Not sure on the rspec-mocks syntax. But that's the general idea.
  #   In any event, what we're really testing here is Artifact behavior, and checking the nearest side effects.

	before do
	  @user = create(:user)
    @user2 = create(:user)
    @admin_user = create(:user)
    @ov_asset = OpenvaultAsset.new(:pid => 'test:1234')
    Fixtures.cwd("#{fixture_path}/pbcore")
    @ov_asset.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
    @ov_asset.save
    @artifact = Artifact.create(:pid => @ov_asset.pid)
    @artifact.save
  end

  it "should email a user when an artifact request is digitizing" do
  	@artifact.request_digitization(@user)
  	@artifact.digitize!(@admin_user)
  	ActionMailer::Base.deliveries.last.to.should == [@user.email]
  end

  it "should email all users associated with artifact when artifact is digitizing" do
  	@artifact.request_digitization(@user)
  	@artifact.request_digitization(@user2)
  	@artifact.digitize!(@admin_user)
  	deliveries = ActionMailer::Base.deliveries[(ActionMailer::Base.deliveries.size - @artifact.users.count)..ActionMailer::Base.deliveries.size]
  	deliveries.collect{|d| d.to}.flatten.should == [@user.email, @user2.email]
  end

  it "should email all users when an artifact request is denied by an admin" do
    @artifact.request_digitization(@user)
    @artifact.request_digitization(@user2)
    @artifact.block!(@admin_user)
    deliveries = ActionMailer::Base.deliveries[(ActionMailer::Base.deliveries.size - @artifact.users.count)..ActionMailer::Base.deliveries.size]
    deliveries.collect{|d| d.to}.flatten.should == [@user.email, @user2.email]
  end

  it "should email a user when an artifact request is withdrawn by an admin" do
    @artifact.request_digitization(@user)
    @artifact.withdraw_request(@user)
    ActionMailer::Base.deliveries.last.to.should == [@user.email]
  end

  let(:user) { create :user }
  let(:artifact) { instance_double(Artifact, pid: 'test:123', title: 'test artifact', asset_path: '/catalog/some-slug') }


  describe '#digitization_requested_email' do
    let(:mail) { UserMailer.digitization_requested_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to eq "WGBH Digitization Request Received"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{artifact.asset_path}")
    end
  end

  describe '#digitization_approval_email' do
    let(:mail) { UserMailer.digitization_approval_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to eq "Your digitization request has been approved"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{catalog_path(artifact.pid)}")
    end
  end

  describe '#digitization_blocked_email' do
    let(:mail) { UserMailer.digitization_blocked_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to eq "Unable to digitize your requested item"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{catalog_path(artifact.pid)}")
    end
  end

  describe '#digitization_published_email', focus: true do
    let(:mail) { UserMailer.digitization_published_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to eq "The item you requested has been published"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{catalog_path(artifact.pid)}")
    end
  end
end