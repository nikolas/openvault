require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  describe '.get_model_for' do

    it 'returns an instance of Series for PBCore xml that describes a series' do
      Openvault::Pbcore.get_model_for(Fixtures.use('mars/series_1.xml')).should be_a Series
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/series_1.xml')).should be_a Series

    end

    it 'returns an instance of Program for PBCore xml that describes a program' do
      Openvault::Pbcore.get_model_for(Fixtures.use('mars/program_1.xml')).should be_a Program
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/program_1.xml')).should be_a Program      
    end

    it 'returns an instance of Image for PBCore xml that describes a image' do
      Openvault::Pbcore.get_model_for(Fixtures.use('mars/image_1.xml')).should be_a Image
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/image_1.xml')).should be_a Image
    end

    it 'returns an instance of Video for PBCore xml that describes a video' do
      Openvault::Pbcore.get_model_for(Fixtures.use('mars/video_1.xml')).should be_a Video
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/video_1.xml')).should be_a Video
    end

    it 'returns an instance of Audio for PBCore xml that describes an audio record' do
      Openvault::Pbcore.get_model_for(Fixtures.use('mars/audio_1.xml')).should be_a Audio
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/march_on_washington/audio_1.xml')).should be_a Audio
    end

    it 'returns an instance of Transcript for PBCore xml that describes a transcript' do
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/transcript_1.xml')).should be_a Transcript
    end
  end

  describe '.is_series?' do
    it 'returns true if pbcore xml describes a series record' do
      Openvault::Pbcore.is_series?(Fixtures.use('mars/series_1.xml')).should == true
      Openvault::Pbcore.is_series?(Fixtures.use('artesia/rock_and_roll/series_1.xml')).should == true
    end
  end

  describe '.is_program?' do
    it 'returns true if pbcore xml describes a program record' do
      Openvault::Pbcore.is_program?(Fixtures.use('mars/program_1.xml')).should == true
      Openvault::Pbcore.is_program?(Fixtures.use('artesia/rock_and_roll/program_1.xml')).should == true
    end
  end

  describe '.is_image?' do
    it 'returns true if pbcore xml describes an image record' do
      Openvault::Pbcore.is_image?(Fixtures.use('mars/image_1.xml')).should == true
      Openvault::Pbcore.is_image?(Fixtures.use('artesia/rock_and_roll/image_1.xml')).should == true
      Openvault::Pbcore.is_image?(Fixtures.use('artesia/march_on_washington/image_1.xml')).should == true
    end
  end

  describe '.is_video?' do
    it 'returns true if pbcore xml describes a viceo record' do
      Openvault::Pbcore.is_video?(Fixtures.use('mars/video_1.xml')).should == true
      Openvault::Pbcore.is_video?(Fixtures.use('artesia/rock_and_roll/video_1.xml')).should == true
    end
  end

  describe '.is_audio?' do
    it 'returns true if pbcore xml describes an audio record' do
      Openvault::Pbcore.is_audio?(Fixtures.use('mars/audio_1.xml')).should == true
    end
  end

  describe '.is_transcript?' do
    it 'returns true if pbcore xml describes a transcript record' do
      Openvault::Pbcore.is_transcript?(Fixtures.use('artesia/rock_and_roll/transcript_1.xml')).should == true
    end
  end

  describe '.ingest!' do

    context 'with empty <pbcoreDocument> nodes as stand alone xml docs, or inside of <pbcoreCollection> nodes, it' do
      before :all do
        @count_before = ActiveFedora::Base.count
        @pids_1 = Openvault::Pbcore.ingest!(Fixtures.raw("pbcore_desc_doc_empty.xml"))
        @pids_2 = Openvault::Pbcore.ingest!(Fixtures.raw("pbcore_collection_empty_docs_1x.xml"))
        @pids_3 = Openvault::Pbcore.ingest!(Fixtures.raw("pbcore_collection_empty_docs_2x.xml"))
      end

      after :all do
        OpenvaultAsset.find(@pids_1 + @pids_2 + @pids_3).each do |obj|
          obj.delete
        end
        ActiveFedora::Base.count.should == @count_before
      end

      it 'returns an array of pids' do
        @pids_1.count.should == 1
        @pids_2.count.should == 1
        @pids_3.count.should == 2
      end

      it 'returns a pid for every subclass of OpenvaultAsset saved' do
        OpenvaultAsset.find(@pids_1).count.should == @pids_1.count
        OpenvaultAsset.find(@pids_2).count.should == @pids_2.count
        OpenvaultAsset.find(@pids_3).count.should == @pids_3.count
      end
    end


    context 'with a subset of related assets that have been transformed from Artesia xml' do
      before :all do
        @count_before = ActiveFedora::Base.count
        # Ingest sample data, and grab all the newly ingested (and related) assets.

        @pids = Openvault::Pbcore.ingest! Fixtures.raw('artesia/rock_and_roll/related_assets_subset.xml')
        @related_assets = {}

        #  now lets organize them in a 2d hash, keyed first by model class, then by UOI_ID
        #  since that is how we will know which models to check.
        @pids.each do |pid|
          asset = OpenvaultAsset.find pid, :cast => true
          @related_assets[asset.class] ||= {}

          # this gets the UOI_ID from the `all_ids' term in the pbcore datastream.
          uoi_id = (asset.pbcore.all_ids.select { |id| id.length >= 40 } ).first

          @related_assets[asset.class][uoi_id] = asset
        end

        # And just for clarity in the following tests, let's pull each set type of asset out into it's own hash.
        @series, @programs, @videos, @images, @transcripts = @related_assets[Series], @related_assets[Program], @related_assets[Video], @related_assets[Image], @related_assets[Transcript]
      end

      after :all do
        @related_assets.each do |klass, assets|
          assets.each do |uoi_id, asset|
            asset.delete
          end
        end
      end

      # This thing has a lot of assertions, but essentially, it's just checking
      # the whole family of related assets to make sure they got related properly.
      it 'relates Series to Programs correctly' do
        @series["34a589fdcb189dec43a5bca693bbc607d544ffa1"].programs.should include @programs["35454c33856948f9b70312078470976ae798ced4"]
        @series["34a589fdcb189dec43a5bca693bbc607d544ffa1"].programs.should include @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @series["34a589fdcb189dec43a5bca693bbc607d544ffa1"].programs.count.should == 2
      end

      it 'relates Programs to Series correctly' do
        @programs["35454c33856948f9b70312078470976ae798ced4"].series.should == @series["34a589fdcb189dec43a5bca693bbc607d544ffa1"]
        @programs["35454c33856948f9b70312078470976ae798ced4"].series.should == @series["34a589fdcb189dec43a5bca693bbc607d544ffa1"]
        @programs.count.should == 2
      end

      it 'relates Programs to Videos correctly' do
        @programs["35454c33856948f9b70312078470976ae798ced4"].videos.should include @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"]
        @programs["35454c33856948f9b70312078470976ae798ced4"].videos.should include @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"]
        @programs["35454c33856948f9b70312078470976ae798ced4"].videos.should include @videos["3b24bdc8021465893b288955eb65c6810c123977"]
        @programs["35454c33856948f9b70312078470976ae798ced4"].videos.should include @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"]
        @programs["35454c33856948f9b70312078470976ae798ced4"].videos.count.should == 4

        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.should include @videos["2bd34fed62072cbc17875bcac1b23884babf1194"]
        @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"].videos.count.should == 6
      end

      it 'relates Videos to Programs correctly' do
        @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"].program.should == @programs["35454c33856948f9b70312078470976ae798ced4"]
        @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"].program.should == @programs["35454c33856948f9b70312078470976ae798ced4"]
        @videos["3b24bdc8021465893b288955eb65c6810c123977"].program.should == @programs["35454c33856948f9b70312078470976ae798ced4"]
        @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"].program.should == @programs["35454c33856948f9b70312078470976ae798ced4"]

        @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
        @videos["2bd34fed62072cbc17875bcac1b23884babf1194"].program.should == @programs["86a31c19d423394cfb42cc2b74ff276ab8fd1a0a"]
      end


      it 'relates Videos to Images correctly' do
        @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"].images.should == [@images["63f7c3602d98ae3a82c1036ffc509751c746d2af"]]
        @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"].images.should == [@images["3a133ee78b53c5064939e6774b2dd30d75937a45"]]
        @videos["3b24bdc8021465893b288955eb65c6810c123977"].images.should == [@images["b790a922cf1c74623f63ca0e05278c99075e4de9"]]
        @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"].images.should == [@images["edf72b4df60d8b055001717005ca4ecb1efe9454"]]
        @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"].images.should == [@images["f7195f086f314cb2884cd4a54231dc287f3caea0"]]
        @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"].images.should == [@images["ed49e6a8b63b03d6fb46756ea5730667f8cc830e"]]
        @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"].images.should == [@images["2c54b7dc7c9705831c8b49b5872a055c329b727e"]]
        @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"].images.should == [@images["ca43effb30355b89dc87e342e844a3b405f3fcec"]]
        @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"].images.should == [@images["6efb6faf96ffe3b3bcbd13c0bf36184b6cd1aca1"]]
        @videos["2bd34fed62072cbc17875bcac1b23884babf1194"].images.should == [@images["06dd1e8c0d8c45584a14005dda02ef73292251bd"]]
      end

      it 'relates Images to Videos correctly' do
        @images["63f7c3602d98ae3a82c1036ffc509751c746d2af"].video.should == @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"]
        @images["3a133ee78b53c5064939e6774b2dd30d75937a45"].video.should == @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"]
        @images["b790a922cf1c74623f63ca0e05278c99075e4de9"].video.should == @videos["3b24bdc8021465893b288955eb65c6810c123977"]
        @images["edf72b4df60d8b055001717005ca4ecb1efe9454"].video.should == @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"]
        @images["f7195f086f314cb2884cd4a54231dc287f3caea0"].video.should == @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"]
        @images["ed49e6a8b63b03d6fb46756ea5730667f8cc830e"].video.should == @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"]
        @images["2c54b7dc7c9705831c8b49b5872a055c329b727e"].video.should == @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"]
        @images["ca43effb30355b89dc87e342e844a3b405f3fcec"].video.should == @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"]
        @images["6efb6faf96ffe3b3bcbd13c0bf36184b6cd1aca1"].video.should == @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"]
        @images["06dd1e8c0d8c45584a14005dda02ef73292251bd"].video.should == @videos["2bd34fed62072cbc17875bcac1b23884babf1194"]
      end

      it 'relates Videos to Transcripts correctly' do
        @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"].transcripts.should == [@transcripts["1a9d85af54c6aa3814d86e26f0105830237b2b89"]]
        @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"].transcripts.should == [@transcripts["d461c41c838e71c6da2a6e2b0409c59a29fb1ffd"]]
        @videos["3b24bdc8021465893b288955eb65c6810c123977"].transcripts.should == [@transcripts["6d0ecff2b83a633ea28718b3d35f579027a29a26"]]
        @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"].transcripts.should == [@transcripts["337223006eb1c0864ee58d8751810059cf90f6c0"]]
        @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"].transcripts.should == [@transcripts["7b07384333b08bd6c12d10cd2b3adb4398c86182"]]
        @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"].transcripts.should == [@transcripts["f3a560974b62c2a589a12704e01a07dedab025bc"]]
        @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"].transcripts.should == [@transcripts["9ef0a439664c31803779f864c39a1333c95a2fbf"]]
        @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"].transcripts.should == [@transcripts["5f649a3416c5ec77f108c2a55c5eeaf83d0a87bd"]]
        @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"].transcripts.should == [@transcripts["3627279b94a950b64778fa5dcaad3efe55d78362"]]
        @videos["2bd34fed62072cbc17875bcac1b23884babf1194"].transcripts.should == [@transcripts["d1d8416d95237d9d561e1a5a038b48b3907ddb7b"]]
      end

      it 'relates Transcripts to Videos correctly' do
        @transcripts["1a9d85af54c6aa3814d86e26f0105830237b2b89"].video.should == @videos["032b0caede61d46034afb24f2dc73e9cae1c96b6"]
        @transcripts["d461c41c838e71c6da2a6e2b0409c59a29fb1ffd"].video.should == @videos["8e6b3bf09c0a41c76e67f91122b15eb17d53ab72"]
        @transcripts["6d0ecff2b83a633ea28718b3d35f579027a29a26"].video.should == @videos["3b24bdc8021465893b288955eb65c6810c123977"]
        @transcripts["337223006eb1c0864ee58d8751810059cf90f6c0"].video.should == @videos["1ce57a5b04a863abbd6522c282ab4156ecefc354"]
        @transcripts["7b07384333b08bd6c12d10cd2b3adb4398c86182"].video.should == @videos["84511cd00c19dc7df0e6ff69a98b8d1c2bf43d0f"]
        @transcripts["f3a560974b62c2a589a12704e01a07dedab025bc"].video.should == @videos["77ba1e3b5b4f06ef3e39b3b8921b6b08e48d136c"]
        @transcripts["9ef0a439664c31803779f864c39a1333c95a2fbf"].video.should == @videos["0d519f03f73f0fe64c8b2834454f06cf967f10ea"]
        @transcripts["5f649a3416c5ec77f108c2a55c5eeaf83d0a87bd"].video.should == @videos["801b56fefa15d2a3ce1bc4b5d30dab82de34141b"]
        @transcripts["3627279b94a950b64778fa5dcaad3efe55d78362"].video.should == @videos["6a1b97baecca413516ac7870a2086767fbe72b1c"]
        @transcripts["d1d8416d95237d9d561e1a5a038b48b3907ddb7b"].video.should == @videos["2bd34fed62072cbc17875bcac1b23884babf1194"]
      end

    end

  
  end
  
end