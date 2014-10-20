require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"


describe Artifact do

	describe 'factory' do
		it 'builds a valid instance by default (no arguments required)' do
			expect(build(:artifact)).to be_valid
		end

		it 'has a sub-factory for digitizations' do
			d = build(:digitization)
			# it is an Artifact instance
			expect(d).to be_a Artifact
			# with :type == 'digitization'
			expect(d.type).to eq 'digitization'
		end
	end


	before do
		@user = create(:user)
		@user2 = create(:user)
		@ov_asset = OpenvaultAsset.new(:pid => 'test:1234')
		Fixtures.cwd("#{fixture_path}/pbcore")
		@ov_asset.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
		@ov_asset.save
		@artifact = Artifact.create(:pid => @ov_asset.pid)
	end
	
	before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

	describe "states" do

		it "should change artifact's state from initiated to requested when user requests digitization" do
			@artifact.request_digitization(@user)
			@artifact.state.should == "requested"
		end

		it "should change artifact's state from requested to digitizing when admin approves request" do
			@artifact.request_digitization(@user)
			@artifact.digitize(@user)
			@artifact.state.should == "digitizing"
		end

		it "should change artifact's state from requested to denied when admin denies request" do
			@artifact.request_digitization(@user)
			@artifact.block(@user)
			@artifact.state.should == "blocked"
		end

		it "artifact saves state of requested after multiple users request digitization" do 
			@user3 = create(:user)
			@artifact.request_digitization(@user)
			@artifact.request_digitization(@user2)
			@artifact.request_digitization(@user3)
			@artifact.state.should == "requested"
		end

		it "should return artifact's state to initiated if last request is withdrawn" do 
			@artifact.request_digitization(@user)
			@artifact.request_digitization(@user2)
			@artifact.withdraw_request(@user)
			@artifact.withdraw_request(@user2)
			@artifact.state.should == "initiated"
		end

		it "should keep artifact's state as 'requested' if a request is withdrawn but there are other remaining requests" do 
			@artifact.request_digitization(@user)
			@artifact.request_digitization(@user2)
			@artifact.withdraw_request(@user)
			@artifact.state.should == "requested"
		end
	end

	describe "sponsors" do

		it 'should make a user who requests an artifact a potential sponsor' do
			@artifact.request_digitization(@user)
			@artifact.potential_sponsors.should include(@user)
		end

		it 'should not make user a confirmed sponsor upon artifact request' do
			@artifact.request_digitization(@user)
			expect(@artifact.sponsors).not_to include(@user)
		end

		it "should remove user from artifact sponsors if artifact request is withdrawn" do
			@artifact.request_digitization(@user)
			@artifact.withdraw_request(@user)
			@artifact.reload
			expect(@artifact.potential_sponsors).not_to include(@user)
		end

		it "should remove user's potential sponsorship if artifact request is withdrawn" do
			@artifact.request_digitization(@user)
			@user.artifacts.reload # simulates user touching/loading/caching the relationship
			@artifact.withdraw_request(@user)
			@user.artifacts.should == []
		end

	end


	describe '#destroy' do
		it 'also destroys all assocaited sponsorships' do
			artifact = create(:artifact, sponsorships: create_list(:sponsorship, 2))
			expect(Sponsorship.where(artifact_id: artifact.id).count).to eq 2
			artifact.destroy
			expect(Sponsorship.where(artifact_id: artifact.id).count).to eq 0
		end
	end

end
