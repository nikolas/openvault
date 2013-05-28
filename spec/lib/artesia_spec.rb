require 'spec_helper'
require 'artesia'

describe Artesia do
  describe Artesia::Ingester do

    let(:valid_file) {File.open("#{fixture_path}/ingest/artesia.xml")}

    it "accepts valid xml (from Artesia export) and saves to fedora" do
      count_before_ingest = ActiveFedora::Base.count
      Artesia::Ingester.ingest!(valid_file.read, 'openvault_testing@wgbh.org')
      # Why 7? Because there are 6 assets in the fixture, +1 for the ingest itself.
      ActiveFedora::Base.count.should == (count_before_ingest + 7)
    end
  end

    
end