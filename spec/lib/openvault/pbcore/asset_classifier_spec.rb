require 'spec_helper'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore::AssetClassifier do

  let(:wrapper_class) { Openvault::Pbcore::AssetClassifier }

  before :all do
    Fixtures.cwd "#{fixture_path}/pbcore"
  end

  describe '#is_series?' do
    it 'returns true if pbcore xml describes a series record' do
      expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/series_1.xml')).is_series?).to be true
    end
  end

  describe '.is_program?' do
    it 'returns true if pbcore xml describes a program record' do
      expect(wrapper_class.new(Fixtures.use('mars/program_1.xml')).is_program?).to be true
      expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/program_1.xml')).is_program?).to be true
    end
  end

  describe '.is_image?' do
    it 'returns true if pbcore xml describes an image record' do
      expect(wrapper_class.new(Fixtures.use('mars/image_1.xml')).is_image?).to be true
      expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/image_1.xml')).is_image?).to be true
      expect(wrapper_class.new(Fixtures.use('artesia/march_on_washington/image_1.xml')).is_image?).to be true
      expect(wrapper_class.new(Fixtures.use('artesia/joyce_chen/image_1.xml')).is_image?).to be true
    end
  end

  describe '.is_video?' do
    it 'returns true if pbcore xml describes a viceo record' do
      expect(wrapper_class.new(Fixtures.use('mars/video_1.xml')).is_video?).to be true
      expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/video_1.xml')).is_video?).to be true
    end
  end

  describe '.is_audio?' do
    it 'returns true if pbcore xml describes an audio record' do
      expect(wrapper_class.new(Fixtures.use('mars/audio_1.xml')).is_audio?).to be true
    end
  end

  describe '.is_transcript?' do
    it 'returns true if pbcore xml describes a transcript record' do
      expect(wrapper_class.new(Fixtures.use('artesia/rock_and_roll/transcript_1.xml')).is_transcript?).to be true
    end
  end
end
