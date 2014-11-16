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

  let(:user) { create :user }
  let(:artifact) { instance_double(Artifact, pid: 'test:123', title: 'test artifact') }

  describe '#request_notification_email', focus: true do
    let(:mail) { AdminMailer.request_notification_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to match "New Digitization Request"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{catalog_path(artifact.pid)}")
    end

    it 'contains the user\'s name' do
      expect(mail.body.encoded).to match user.to_s
    end
  end

  describe '#request_withdrawn_email', focus: true do
    let(:mail) { AdminMailer.request_withdrawn_email(user, artifact) }

    it 'has an appropriate subject' do
      expect(mail.subject).to match "Digitization Request Withdrawn"
    end

    it 'contains a link to the artifact\'s asset' do
      expect(mail.body.encoded).to have_link(artifact.title, href: "http://openvault.wgbh.org#{catalog_path(artifact.pid)}")
    end

    it 'contains the user\'s name' do
      expect(mail.body.encoded).to match user.to_s
    end 
  end

end
