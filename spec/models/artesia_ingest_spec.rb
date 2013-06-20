require 'spec_helper'

describe ArtesiaIngest do

  subject(:artesia_ingest) { ArtesiaIngest.new }

  # zoom_sample.xml is an export from Artesia, containing 6 interrelated assets.
  let!(:valid_xml) { File.read("#{fixture_path}/artesia_ingest/teams_asset_file.zoom_sample.xml") }
  let(:invalid_xml) { 'this is not xml' }
  let(:depositor) { 'openvault_testing@wgbh.org' }

  describe '#save_all!' do
    it 'saves 1 record for the ingest itself, and 1 record for each child asset' do
      count_before_ingest = ActiveFedora::Base.count
      artesia_ingest.teams_asset_file.set_xml valid_xml
      artesia_ingest.depositor = depositor
      artesia_ingest.save_all!
      ActiveFedora::Base.count.should == (count_before_ingest + 7)
    end

    pending "raises an error if xml is invalid" do
      expect { artesia_ingest.set_teams_asset_file invalid_xml }.to raise_error
    end

    pending "should not insert a record for the ingest if if xml is invalid" do
      count_before_ingest = ActiveFedora::Base.count

      begin
        artesia_ingest.set_teams_asset_file invalid_xml
      rescue
        # Get around the error that is raised with invalid_xml
      end

      artesia_ingest.save_all!(depositor)

      # Count should be the same
      ActiveFedora::Base.count.should == count_before_ingest
    end
  end
end