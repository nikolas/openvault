require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::DescriptionDocumentWrapper do

  let(:wrapper_class) { Openvault::Pbcore::DescriptionDocumentWrapper }

  describe '#model' do

    describe 'for any metadata sample we have of a "series" record' do
      it 'returns a Series model' do
        expect(wrapper_class.new(Fixtures.use('mars/series_1.xml')).model).to be_a Series
        expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/series_1.xml')).model).to be_a Series
      end
    end

    describe 'for any metadata sample we have of a "program" record' do
      it 'returns a Program model', broken: true do
        expect(wrapper_class.new(Fixtures.use('mars/program_1.xml')).model).to be_a Program
        expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/program_1.xml')).model).to be_a Program
        expect(wrapper_class.new(Fixtures.use('artesia/patriots_day/program_1.xml')).model).to be_a Program
      end
    end

    describe 'for any metadta sample we have of an "image" record' do
      it 'returns an Image model' do
        expect(wrapper_class.new(Fixtures.use('mars/image_1.xml')).model).to be_a Image
        expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/image_1.xml')).model).to be_a Image
      end
    end

    describe 'for any metadata sample we have of a "video" record' do
      it 'returns a Video model' do
        expect(wrapper_class.new(Fixtures.use('mars/video_1.xml')).model).to be_a Video
        expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/video_1.xml')).model).to be_a Video
      end
    end

    describe 'for any metadata sample we have of a "video" record' do
      it 'returns an Audio model' do
        expect(wrapper_class.new(Fixtures.use('mars/audio_1.xml')).model).to be_a Audio
        expect(wrapper_class.new(Fixtures.use('artesia/march_on_washington/audio_1.xml')).model).to be_a Audio
      end
    end

    
    describe 'for any metadata sample we have of a "transcript" record' do
      it 'returns a Transcript model', broken: true do
        expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/transcript_1.xml')).model).to be_a Transcript
      end
    end
  

    it 'returns a new, unsaved model if values from PbcoreDescDoc#all_ids have not yet been saved' do
      pbcore_desc_doc = Fixtures.use('artesia/rock_and_roll/series_1.xml')
      pbcore_desc_doc.all_ids = [(rand*10**15).to_i.to_s]
      wrapper_class.new(pbcore_desc_doc).model.persisted?.should == false
    end


    it 'checks to see if model exists with values for <pbcoreIdentifier> and if so, returns that model' do
      model = wrapper_class.new(Fixtures.use('artesia/rock_and_roll/series_1.xml')).model
      model.save!
      wrapper_class.new(Fixtures.use('artesia/rock_and_roll/series_1.xml')).model.should == model
    end
  end


  # describe '#is_series?' do
  #   it 'returns true if pbcore xml describes a series record' do
  #     expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/series_1.xml')).is_series?).to be_true
  #   end 
  # end

  # describe '.is_program?' do
  #   it 'returns true if pbcore xml describes a program record' sw
  #     expect(wrapper_class.new(Fixtures.use('mars/program_1.xml')).is_program?).to be_true
  #     expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/program_1.xml')).is_program?).to be_true
  #   end
  # end

  # describe '.is_image?' do
  #   it 'returns true if pbcore xml describes an image record' do
  #     expect(wrapper_class.new(Fixtures.use('mars/image_1.xml')).is_image?).to be_true
  #     expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/image_1.xml')).is_image?).to be_true
  #     expect(wrapper_class.new(Fixtures.use('artesia/march_on_washington/image_1.xml')).is_image?).to be_true
  #   end
  # end

  # describe '.is_video?' do
  #   it 'returns true if pbcore xml describes a viceo record' do
  #     expect(wrapper_class.new(Fixtures.use('mars/video_1.xml')).is_video?).to be_true
  #     expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/video_1.xml')).is_video?).to be_true
  #   end
  # end

  # describe '.is_audio?' do
  #   it 'returns true if pbcore xml describes an audio record' do
  #     expect(wrapper_class.new(Fixtures.use('mars/audio_1.xml')).is_audio?).to be_true
  #   end
  # end

  # describe '.is_transcript?' do
  #   it 'returns true if pbcore xml describes a transcript record' do
  #     expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/transcript_1.xml')).is_transcript?).to be_true
  #   end
  # end

end