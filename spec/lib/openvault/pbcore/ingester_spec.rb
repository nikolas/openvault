require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::Ingester do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  describe '.ingest' do

    context 'with empty <pbcoreDocument> nodes as stand alone xml docs, or inside of <pbcoreCollection> nodes, it' do
      let(:ingester) { Openvault::Pbcore::Ingester.new }
      let(:pids_1) { ingester.xml = Fixtures.raw("pbcore_desc_doc_empty.xml"); ingester.ingest }
      let(:pids_2) { ingester.xml = Fixtures.raw("pbcore_collection_empty_docs_1x.xml"); ingester.ingest }
      let(:pids_3) { ingester.xml = Fixtures.raw("pbcore_collection_empty_docs_2x.xml"); ingester.ingest }

      before :all do
        @count_before = ActiveFedora::Base.count
      end

      it 'returns an array of pids', broken: true do
        pids_1.count.should == 1
        pids_2.count.should == 1
        pids_3.count.should == 2
      end

      it 'returns a pid for every subclass of OpenvaultAsset saved' do
        OpenvaultAsset.find(pids_1).count.should == pids_1.count
        OpenvaultAsset.find(pids_2).count.should == pids_2.count
        OpenvaultAsset.find(pids_3).count.should == pids_3.count
      end
    end

    context 'with a subset of related assets that have been transformed from Artesia xml' do
      before :all do
        # First ingest a bunch of related assets
        Openvault::Pbcore::Ingester.new(Fixtures.raw('artesia/rock_and_roll/related_assets_subset.xml')).ingest

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
        @series.programs.should include @program_1
        @series.programs.should include @program_2
      end

      it 'relates Programs to Series correctly' do
        @program_1.series.should == @series
        @program_1.series.should == @series
      end

      it 'relates Programs to Videos correctly', broken: true do
        @program_1.videos.should include @video_1
        @program_1.videos.should include @video_2
        @program_1.videos.should include @video_3
        @program_1.videos.should include @video_4

        @program_2.videos.should include @video_5
        @program_2.videos.should include @video_6
        @program_2.videos.should include @video_7
        @program_2.videos.should include @video_8
        @program_2.videos.should include @video_9
        @program_2.videos.should include @video_10
      end

      it 'relates Videos to Programs correctly', broken: true do
        @video_1.program.should == @program_1
        @video_2.program.should == @program_1
        @video_3.program.should == @program_1
        @video_4.program.should == @program_1

        @video_5.program.should == @program_2
        @video_6.program.should == @program_2
        @video_7.program.should == @program_2
        @video_8.program.should == @program_2
        @video_9.program.should == @program_2
        @video_10.program.should == @program_2
      end


      it 'relates Videos to Images correctly' do
        @video_1.images.should == [@image_1]
        @video_2.images.should == [@image_2]
        @video_3.images.should == [@image_3]
        @video_4.images.should == [@image_4]
        @video_5.images.should == [@image_5]
        @video_6.images.should == [@image_6]
        @video_7.images.should == [@image_7]
        @video_8.images.should == [@image_8]
        @video_9.images.should == [@image_9]
        @video_10.images.should == [@image_10]
      end

      it 'relates Images to Videos correctly' do
        @image_1.video.should == @video_1
        @image_2.video.should == @video_2
        @image_3.video.should == @video_3
        @image_4.video.should == @video_4
        @image_5.video.should == @video_5
        @image_6.video.should == @video_6
        @image_7.video.should == @video_7
        @image_8.video.should == @video_8
        @image_9.video.should == @video_9
        @image_10.video.should == @video_10
      end

      it 'relates Videos to Transcripts correctly', broken: true do
        @video_1.transcripts.should == [@transcript_1]
        @video_2.transcripts.should == [@transcript_2]
        @video_3.transcripts.should == [@transcript_3]
        @video_4.transcripts.should == [@transcript_4]
        @video_5.transcripts.should == [@transcript_5]
        @video_6.transcripts.should == [@transcript_6]
        @video_7.transcripts.should == [@transcript_7]
        @video_8.transcripts.should == [@transcript_8]
        @video_9.transcripts.should == [@transcript_9]
        @video_10.transcripts.should == [@transcript_10]
      end

      it 'relates Transcripts to Videos correctly', broken: true do
        @transcript_1.video.should == @video_1
        @transcript_2.video.should == @video_2
        @transcript_3.video.should == @video_3
        @transcript_4.video.should == @video_4
        @transcript_5.video.should == @video_5
        @transcript_6.video.should == @video_6
        @transcript_7.video.should == @video_7
        @transcript_8.video.should == @video_8
        @transcript_9.video.should == @video_9
        @transcript_10.video.should == @video_10
      end

    end


  end

end
