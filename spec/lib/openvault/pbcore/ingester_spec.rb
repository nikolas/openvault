require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::Ingester do

  before(:all) { Fixtures.cwd("#{fixture_path}/pbcore") }

  describe '#logger' do
    it 'returns an instance of Logger' do
      ingester = Openvault::Pbcore::Ingester.new
      expect(ingester.logger).to be_a Logger
    end
  end

  describe '#logger=' do
    it 'raises an error if you attempt to pass something other than Logger' do
      ingester = Openvault::Pbcore::Ingester.new
      expect{ ingester.logger = true }.to raise_error ArgumentError
    end

    it 'sets @logger to an instance of Logger' do
      ingester = Openvault::Pbcore::Ingester.new
      expect{ ingester.logger = Logger.new(STDOUT) }.to_not raise_error
    end
  end

  describe '#ingest' do


    context 'with a subset of related assets that have been transformed from Artesia xml' do
      before :all do
        # First ingest a bunch of related assets
        ingester = Openvault::Pbcore::Ingester.new(Fixtures.raw('artesia/rock_and_roll/related_assets_subset.xml'))
        ingester.policy = :replace_if_exists
        ingester.ingest!

        # Now look up the assets just ingested and use them for testing the relationships.
        @series = Series.find({:all_ids_tesim => "34a589fdcb189dec43a5bca693bbc607d544ffa1"}).first

        @program_1 = Program.find({:all_ids_tesim => "35454c33856948f9b70312078470976ae798ced4"}).first
        @program_2 = Program.find({:all_ids_tesim => "86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"}).first

        @video_1 = Video.find({:all_ids_tesim => "032b0caede61d46034afb24f2dc73e9cae1c96b6"}).first
        @video_2 = Video.find({:all_ids_tesim => "8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"}).first
        @video_3 = Video.find({:all_ids_tesim => "3b24bdc8021465893b288955eb65c6810c123977"}).first
        @video_4 = Video.find({:all_ids_tesim => "1ce57a5b04a863abbd6522c282ab4156ecefc354"}).first
        @video_5 = Video.find({:all_ids_tesim => "84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"}).first
        @video_6 = Video.find({:all_ids_tesim => "77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"}).first
        @video_7 = Video.find({:all_ids_tesim => "0d519f03f73f0fe64c8b2834454f06cf967f10ea"}).first
        @video_8 = Video.find({:all_ids_tesim => "801b56fefa15d2a3ce1bc4b5d30dab82de34141b"}).first
        @video_9 = Video.find({:all_ids_tesim => "6a1b97baecca413516ac7870a2086767fbe72b1c"}).first
        @video_10 = Video.find({:all_ids_tesim => "2bd34fed62072cbc17875bcac1b23884babf1194"}).first

        @image_1 = Image.find({:all_ids_tesim => "63f7c3602d98ae3a82c1036ffc509751c746d2af"}).first
        @image_2 = Image.find({:all_ids_tesim => "3a133ee78b53c5064939e6774b2dd30d75937a45"}).first
        @image_3 = Image.find({:all_ids_tesim => "b790a922cf1c74623f63ca0e05278c99075e4de9"}).first
        @image_4 = Image.find({:all_ids_tesim => "edf72b4df60d8b055001717005ca4ecb1efe9454"}).first
        @image_5 = Image.find({:all_ids_tesim => "f7195f086f314cb2884cd4a54231dc287f3caea0"}).first
        @image_6 = Image.find({:all_ids_tesim => "ed49e6a8b63b03d6fb46756ea5730667f8cc830e"}).first
        @image_7 = Image.find({:all_ids_tesim => "2c54b7dc7c9705831c8b49b5872a055c329b727e"}).first
        @image_8 = Image.find({:all_ids_tesim => "ca43effb30355b89dc87e342e844a3b405f3fcec"}).first
        @image_9 = Image.find({:all_ids_tesim => "6efb6faf96ffe3b3bcbd13c0bf36184b6cd1aca1"}).first
        @image_10 = Image.find({:all_ids_tesim => "06dd1e8c0d8c45584a14005dda02ef73292251bd"}).first

        @transcript_1 = Transcript.find({:all_ids_tesim => "1a9d85af54c6aa3814d86e26f0105830237b2b89"}).first
        @transcript_2 = Transcript.find({:all_ids_tesim => "d461c41c838e71c6da2a6e2b0409c59a29fb1ffd"}).first
        @transcript_3 = Transcript.find({:all_ids_tesim => "6d0ecff2b83a633ea28718b3d35f579027a29a26"}).first
        @transcript_4 = Transcript.find({:all_ids_tesim => "337223006eb1c0864ee58d8751810059cf90f6c0"}).first
        @transcript_5 = Transcript.find({:all_ids_tesim => "7b07384333b08bd6c12d10cd2b3adb4398c86182"}).first
        @transcript_6 = Transcript.find({:all_ids_tesim => "f3a560974b62c2a589a12704e01a07dedab025bc"}).first
        @transcript_7 = Transcript.find({:all_ids_tesim => "9ef0a439664c31803779f864c39a1333c95a2fbf"}).first
        @transcript_8 = Transcript.find({:all_ids_tesim => "5f649a3416c5ec77f108c2a55c5eeaf83d0a87bd"}).first
        @transcript_9 = Transcript.find({:all_ids_tesim => "3627279b94a950b64778fa5dcaad3efe55d78362"}).first
        @transcript_10 = Transcript.find({:all_ids_tesim => "d1d8416d95237d9d561e1a5a038b48b3907ddb7b"}).first

      end

      # This thing has a lot of assertions, but essentially, it's just checking
      # the whole family of related assets to make sure they got related properly.
      it 'relates Series to Programs correctly' do
        expect(@series.programs.to_a).to include(@program_1)
        expect(@series.programs.to_a).to include(@program_2)
      end

      it 'relates Programs to Series correctly' do
        expect(@program_1.series).to eq @series
        expect(@program_1.series).to eq @series
      end

      it 'relates Programs to Videos correctly' do
        expect(@program_1.videos.to_a).to include @video_1
        expect(@program_1.videos.to_a).to include @video_2
        expect(@program_1.videos.to_a).to include @video_3
        expect(@program_1.videos.to_a).to include @video_4

        expect(@program_2.videos.to_a).to include @video_5
        expect(@program_2.videos.to_a).to include @video_6
        expect(@program_2.videos.to_a).to include @video_7
        expect(@program_2.videos.to_a).to include @video_8
        expect(@program_2.videos.to_a).to include @video_9
        expect(@program_2.videos.to_a).to include @video_10
      end

      it 'relates Videos to Programs correctly' do
        expect(@video_1.program).to eq @program_1
        expect(@video_2.program).to eq @program_1
        expect(@video_3.program).to eq @program_1
        expect(@video_4.program).to eq @program_1

        expect(@video_5.program).to eq @program_2
        expect(@video_6.program).to eq @program_2
        expect(@video_7.program).to eq @program_2
        expect(@video_8.program).to eq @program_2
        expect(@video_9.program).to eq @program_2
        @video_10.program.should == @program_2
      end


      it 'relates Videos to Images correctly' do
        expect(@video_1.images).to eq [@image_1]
        expect(@video_2.images).to eq [@image_2]
        expect(@video_3.images).to eq [@image_3]
        expect(@video_4.images).to eq [@image_4]
        expect(@video_5.images).to eq [@image_5]
        expect(@video_6.images).to eq [@image_6]
        expect(@video_7.images).to eq [@image_7]
        expect(@video_8.images).to eq [@image_8]
        expect(@video_9.images).to eq [@image_9]
        @video_10.images.should == [@image_10]
      end

      it 'relates Images to Videos correctly' do
        expect(@image_1.video).to eq @video_1
        expect(@image_2.video).to eq @video_2
        expect(@image_3.video).to eq @video_3
        expect(@image_4.video).to eq @video_4
        expect(@image_5.video).to eq @video_5
        expect(@image_6.video).to eq @video_6
        expect(@image_7.video).to eq @video_7
        expect(@image_8.video).to eq @video_8
        expect(@image_9.video).to eq @video_9
        @image_10.video.should == @video_10
      end

      it 'relates Videos to Transcripts correctly', broken: true do
        expect(@video_1.transcripts).to eq [@transcript_1]
        expect(@video_2.transcripts).to eq [@transcript_2]
        expect(@video_3.transcripts).to eq [@transcript_3]
        expect(@video_4.transcripts).to eq [@transcript_4]
        expect(@video_5.transcripts).to eq [@transcript_5]
        expect(@video_6.transcripts).to eq [@transcript_6]
        expect(@video_7.transcripts).to eq [@transcript_7]
        expect(@video_8.transcripts).to eq [@transcript_8]
        expect(@video_9.transcripts).to eq [@transcript_9]
        @video_10.transcripts.should == [@transcript_10]
      end

      it 'relates Transcripts to Videos correctly', broken: true do
        expect(@transcript_1.video).to eq @video_1
        expect(@transcript_2.video).to eq @video_2
        expect(@transcript_3.video).to eq @video_3
        expect(@transcript_4.video).to eq @video_4
        expect(@transcript_5.video).to eq @video_5
        expect(@transcript_6.video).to eq @video_6
        expect(@transcript_7.video).to eq @video_7
        expect(@transcript_8.video).to eq @video_8
        expect(@transcript_9.video).to eq @video_9
        @transcript_10.video.should == @video_10
      end

    end


    context 'when Fedora object exists with pbcore datasream that matches all pbcoreIdentifiers' do

      before do
        @pbcore_desc_doc = build(:pbcore_desc_doc, :with_artesia_id, :with_series_title)

        ov_asset = OpenvaultAsset.new

        # We can't just assign the datastream directly, because that hasn't been built.
        # There might be a better way to do this, but for now, assign the Nokogiri object.
        ov_asset.pbcore.ng_xml = @pbcore_desc_doc.ng_xml
        ov_asset.save!

        @saved_pid = ov_asset.pid

        @ingester = Openvault::Pbcore::Ingester.new(@pbcore_desc_doc.to_xml)


      end

      context 'and when policy == :skip_if_exists' do
        it 'does not ingest the record.' do
          @ingester.policy = :skip_if_exists
          @ingester.ingest!

          # Expect the ingester to not have ingested anything
          expect(@ingester.pids).to be_empty

          # And expect the record that was found to still be there
          expect{ OpenvaultAsset.find(@saved_pid, cast: true) }.to_not raise_error
        end
      end

      context 'and when policy == :replace_if_exists,' do

        context 'and when the new pbcore xml does not result in a reclassification of the object' do

          # NOTE: this is the same as 'when policy == :update_if_exsts'
          it 'updates the existing record.' do

            @ingester.policy = :update_if_exists
            @ingester.ingest!

            expect(@ingester.pids).to_not be_empty

            # Expect the ingested pid to be the same as the previously saved pid.
            expect(@ingester.pids.first).to eq @saved_pid
            
            # And expect the previously saved pid to still be there.
            expect{OpenvaultAsset.find(@saved_pid, cast: true)}.to_not raise_error
          end
        end


        context 'and when the new pbcore xml results in a reclassification of the object' do
          it 'replaces the record with a new one.' do

            # Notice that we change it to have a program title instead of a series title. This should be sufficient to trigrer
            # a reclassification of what the asset should be, and thus require the thing to be replaced.
            pbcore_with_same_id_but_different_type = build(:pbcore_desc_doc, :with_program_title, all_ids: @pbcore_desc_doc.all_ids)

            @ingester = Openvault::Pbcore::Ingester.new(pbcore_with_same_id_but_different_type.to_xml)

            @ingester.policy = :replace_if_exists
            @ingester.ingest!

            expect(@ingester.pids.count).to eq 1

            # Expect the ingested record's pid to not match the previous pid.
            expect(@ingester.pids.first).to_not eq @saved_pid

            # Expect the orig object with @saved_pid to have been deleted by the ingester.
            expect{ OpenvaultAsset.find(@saved_pid, cast: true) }.to raise_error ActiveFedora::ObjectNotFoundError
          end
        end
  
      end

      context 'and when policy == :update_if_exists' do

        # NOTE: this is the same as 'when policy == :replace_if_exsts, and when the new pbcore xml does not result in a reclassification of the object'
        it 'updates the existing record.' do

          @ingester.policy = :update_if_exists
          @ingester.ingest!

          expect(@ingester.pids).to_not be_empty

          # Expect the ingested pid to be the same as the previously saved pid.
          expect(@ingester.pids.first).to eq @saved_pid
          
          # And expect the previously saved pid to still be there.
          expect{OpenvaultAsset.find(@saved_pid, cast: true)}.to_not raise_error
        end
      end
    end

  end

end
