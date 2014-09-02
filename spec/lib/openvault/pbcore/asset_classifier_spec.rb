require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::AssetClassifier do

  describe 'factories' do
    
    def classify(object)
      Openvault::Pbcore::AssetClassifier.classify object.pbcore
    end
    
    [Series, Program, Video, Audio, Image, Transcript].each do |klass|
      it klass do
        symbol = klass.name.underscore.to_sym
        expect(classify build symbol).to be klass
      end
    end
    
  end
  
  
  describe 'fixtures' do
    
    before :all do
      Fixtures.cwd "#{fixture_path}/pbcore"
    end

    def classify(path)
      fixture = Fixtures.use(path)
      Openvault::Pbcore::AssetClassifier.classify(fixture)
    end

    def expect_class(klass, fixture_paths)
      fixture_paths.each do |path|
        begin
          expect(classify(path)).to be(klass),
            "Expected #{path} to be classified as #{klass}"
        rescue RuntimeError => e
          fail "Expected #{path} to be classified as #{klass}, instead of throwing '#{e}'"
        end
      end
    end
    
    it 'for Series' do
      expect_class Series, [
        'artesia/rock_and_roll/series_1.xml']
    end
    
    it 'for Program' do
      expect_class Program, [
          'mars/program_1.xml',
          'artesia/rock_and_roll/program_1.xml']
    end
    
    it 'for Image' do
      expect_class Image, [
          'mars/image_1.xml',
          'artesia/rock_and_roll/image_1.xml',
          'artesia/march_on_washington/image_1.xml',
          'artesia/joyce_chen/image_1.xml']
    end
    
    it 'for Video' do
      expect_class Video, [
          'mars/video_1.xml',
          'artesia/rock_and_roll/video_1.xml']
    end 
    
    it 'for Audio' do
      expect_class Audio, [
        'mars/audio_1.xml']
    end
    
    it 'for Transcript' do
      expect_class Transcript, [
        'artesia/rock_and_roll/transcript_1.xml']
    end
    
    describe 'exception' do
      it 'is raised if multiple models apply' do
        expect {classify('artesia/joyce_chen/multiple_models.xml')}.to \
          raise_error("Multiple matching AF-models: [Video, Image]")
      end
      # TODO: test no classifications
    end
    
  end

  
end
