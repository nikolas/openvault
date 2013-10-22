require 'spec_helper'
require 'openvault'
require 'openvault/pbcore'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::Pbcore do

  describe '.get_model_for' do

    before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

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
      Openvault::Pbcore.get_model_for(Fixtures.use('artesia/rock_and_roll/video_element_1.xml')).should be_a Video
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
    end
  end

  describe '.is_video?' do
    it 'returns true if pbcore xml describes a viceo record' do
      Openvault::Pbcore.is_video?(Fixtures.use('mars/video_1.xml')).should == true
      Openvault::Pbcore.is_video?(Fixtures.use('artesia/rock_and_roll/video_element_1.xml')).should == true
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
  
end