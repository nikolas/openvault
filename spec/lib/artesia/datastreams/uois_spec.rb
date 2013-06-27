require 'spec_helper'
require 'artesia/datastreams/uois'

describe Artesia::Datastreams::UOIS do

  let(:uois_program) { File.read('./spec/fixtures/artesia_ingest/zoom/uois_program.xml') }
  let(:uois_series) { File.read('./spec/fixtures/artesia_ingest/zoom/uois_series.xml') }
  let(:uois_transcript) { File.read('./spec/fixtures/artesia_ingest/zoom/uois_transcript.xml') }
  let(:uois_video_viewing_copy) { File.read('./spec/fixtures/artesia_ingest/zoom/uois_video_viewing_copy.xml') }
  let(:uois_image) { File.read('./spec/fixtures/artesia_ingest/zoom/uois_image.xml') }
  let(:uois) { Datastream::UOIS.new }

  describe '.identify_asset_type' do

    pending 'correctly identifies a program type' do
      uois.set_xml uois_program
      Artesia::Datastreams::UOIS.determine_asset_type(uois).should == :program
    end

    pending 'correctly identifies a series type' do
      uois.set_xml uois_series
      Artesia::Datastreams::UOIS.determine_asset_type(uois).should == :series
    end

    pending 'correctly identifies a transcript type' do
      uois.set_xml uois_transcript
      Artesia::Datastreams::UOIS.determine_asset_type(uois).should == :transcript
    end

    pending 'correctly identifies a video type' do
      uois.set_xml uois_video_viewing_copy
      Artesia::Datastreams::UOIS.determine_asset_type(uois).should == :video_viewing_copy
    end

    pending 'correctly identifies a image type' do
      uois.set_xml uois_image
      Artesia::Datastreams::UOIS.determine_asset_type(uois).should == :image
    end
  end

end