# encoding: utf-8

require 'spec_helper'

describe Datastream::UOIS do

  # This array specifies which <TEAMS_ASSET_FILE> xml fixtures to use.
  #
  # It is structured like so:
  # fixtures = {
  #   "path/to/fixture/teams_asset_file.xml" => {
  #     :type_of_item => [array of UOI_IDs to test for :type_of_item]
  #   }
  # }
  # 
  # The <UOIS> xml for each :type_of_item is then passed to new Datastream::UOIS
  # objets which are stored in the hash fixture[:uois], keyed by :type_of_item
  # to be used in subsequent tests.
  fixtures = {
    
    # Zoom!
    "zoom" => {
      :teams_asset_file => "#{fixture_path}/teams_asset_files/zoom.xml",
      :uoi_ids => {
        :series => ["f6d9c1e1c90b14c0f18088e51d139281d7f2ecd1"],
        :program => ["e3616b02f7257101d85c4a0b8e5e7f119ca0556a"],
        :collection => ["ac99f3707a11b13f224eba8494a6e52d1147b305"],
        :video => [
          "e3616b02f7257101d85c4a0b8e5e7f119ca0556a",
          "60982844daf6dafc6e20ca9aadd1bc010b80c533",
          "e5551726166cf29bf24f6b32a34edecaa1ee17c2"
        ],
        :image => ["57939d888c14d68ed4e603a17604f693c880e88b"]
      }
    },

    # Rock and Roll
    "rock_and_roll" => {
      :teams_asset_file => "#{fixture_path}/teams_asset_files/rock_and_roll.xml",
      :uoi_ids => {
        :series => ["34a589fdcb189dec43a5bca693bbc607d544ffa1"],
        :program => ["35454c33856948f9b70312078470976ae798ced4"],
        :video => [
          "4e5e1e72d95f00a35ccff6b1992149a668d61196",
          "44f91989a54c207176af576bd14629000812ba87",
          "02371942bd8cd65a95722996d07671a74953684f",
          "36929d2275b379263aee29c8760a98e3af8e7097",
          "ff2d1faa58fa0b0f915be25acdd58c96f06d20a2",
          "dc3d848fb546b3a48c9461c8d5140d2959bddaba",
          "c2342c6677644167cd1a723714065d5b1d3e1d4e",
          "c1d50950185a7c773ea154875892c9b32a998718"
        ],
        :image => [
          "5fc2c6174b99b8724803fd74e93034fe31cd186f",
          "42a5a946dc77f51ba077ee2ac54279b0546e0259"
        ],
        :transcript => ["9de1adedf24bf71802851c0ba923018f8916acce"]
      }
    },

    # March on Washington
    "march_on_washington" => {
      :teams_asset_file => "#{fixture_path}/teams_asset_files/march_on_washington.xml",
      :uoi_ids => {
        :series => [],
        :program => [],
        :video => [],
        :image => [],
        :transcript => [],
        :audio => [
          "09b97aae9ffdc2df35aab7d997b42e6cb6ffa6eb"
        ]
      }
    },

    # Patriot's Day
    "patriots_day" => {
      :teams_asset_file => "#{fixture_path}/teams_asset_files/patriots_day.xml",
      :uoi_ids => {
        :series => [],
        :program => [],
        :video => [],
        :image => [],
        :transcript => [],
        :audio => [],
      }
    }
  } # end fixtures = {...}


  # Create new Datastream::UOIS for each <UOIS> xml specified by for the uoi_ids in 'fixtures' hash,
  # and collect them together by their type, i.e. :series, :program, :video, etc.
  fixtures.each do |label, fixture|
    # Parse the <TEAMS_ASSET_FILE> xml into a Nokogiri XML Document.
    ng = Nokogiri::XML(File.read(fixture[:teams_asset_file])) do |config|
      config.strict
    end
    uois_datastreams = {}

    # For each type (i.e. :series, :program, etc) ...
    fixture[:uoi_ids].each do |type, uoi_ids_array|
      # For each uoi_id ...
      uoi_ids_array.each do |uoi_id|

        # Create a new Datastream::UOIS object.
        uois_datastream = Datastream::UOIS.new

        # Use Nokogiri xpath to get the <UOIS> xml, and pass it to the Datastream::UOIS object.
        uois_datastream.set_xml ng.xpath("//UOIS[@UOI_ID='#{uoi_id}']").to_xml

        # Append new Datastream::UOIS object to array of objects, keyed by type.
        uois_datastreams[type] ||= []
        uois_datastreams[type] << uois_datastream
      end
    end

    # Put the hash of Datastream::UOIS objects into the 'fixture' hash for use in tests.
    fixture[:uois] = uois_datastreams
  end

          
  fixtures.each do |label, fixture|

    # Create a context for each of the fixtures. This helps with testing output to identify the fixture file.
    context "for teams_asset_file=\"#{fixture[:teams_asset_file]}\"" do

      fixture[:uois].each do |type, uois_datastreams|
        uois_datastreams.each do |uois|

          # Create a context for each UOI_ID. This helps with testing output to identify which <UOIS> xml we're testing.
          context "and UOI_ID=\"#{uois.uoi_id.first}\"" do

            describe '#is_series?' do
              if (type == :series)
                # If <UOIS> xml describes a series, then #is_series? should be true.
                it 'returns true if <UOIS> xml describes a series' do
                  uois.is_series?.should == true
                end
              else
                # If <UOIS> xml describes anything else, #is_series? should be false.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_series?.should == false
                end
              end
            end

            describe '#is_program?' do
              if (type == :program)
                # If <UOIS> xml describes a program, then #is_program? should be true.
                it 'returns true if <UOIS> xml describes a program' do
                  uois.is_program?.should == true
                end
              elsif (![:video, :audio].include?(type))
                # If <UOIS> xml describes a anything other than a program, a video, or audio, then #is_program? should be false.
                # NOTE: Some video and audio records may also act as program record.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_program?.should == false
                end
              end
            end



            describe '#is_collection?' do
              if (type == :collection)
                # If <UOIS> xml describes a collection, then #is_collection? should be true.
                it 'returns true if <UOIS> xml describes a collection' do
                  uois.is_collection?.should == true
                end
              else
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_collection?.should == false
                end
              end
            end

            describe '#is_video?' do
              if (type == :video)
                # If <UOIS> xml describes a video, then #is_video? should be true.
                it 'returns true if <UOIS> xml describes a video' do
                  uois.is_video?.should == true
                end
              elsif(![:program].include?(type))
                # If <UOIS> xml describes a anything other than a video, or program then #is_video? should be false.
                # NOTE: Some video records may also act as program record.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_video?.should == false
                end
              end
  
            end

            describe '#is_audio?' do
              if (type == :audio)
                # If <UOIS> xml describes a audio, then #is_audio? should be true.
                it 'returns true if <UOIS> xml describes audio' do
                  uois.is_audio?.should == true
                end
              elsif (![:program].include?(type))
                # If <UOIS> xml describes a anything other than audio, or a program then #is_audio? should be false.
                # NOTE: Some audio records may also act as program record.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_audio?.should == false
                end
              end
            end

            describe '#is_image?' do
              if (type == :image)
                # If <UOIS> xml describes a image, then #is_image? should be true.
                it 'returns true if <UOIS> xml describes a image' do
                  uois.is_image?.should == true
                end
              else
                # If <UOIS> xml describes a anything other than an image, then #is_image? should return false.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_image?.should == false
                end
              end
  
            end

            describe '#is_transcript?' do
              if (type == :transcript)
                it 'returns true if <UOIS> xml describes a transcript' do
                  uois.is_transcript?.should == true
                end
              else
                # If <UOIS> xml describes a anything other than a transcript, #is_transcript? should return false.
                it "returns false if <UOIS> xml describes a #{type.to_s.sub('_', ' ')}" do
                  uois.is_transcript?.should == false
                end
              end
            end

          end # end context "and UOI_ID=...""
        end # end uois_datastreams.each
      end # end fixture[:uois].each
    end # end context "for teams_asset_file=..." 
  end # end fixtures.each
end