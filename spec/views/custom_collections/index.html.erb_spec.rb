require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe 'custom_collections/index' do

  context 'for custom collections whose summary is longer than 30 characters' do

    before do
      @custom_collections = [create(:custom_collection, summary: Faker::Lorem.sentences(300).join(' '))]
    end

    it 'displays the first 300 characters, with a "read more" link' do
      render
      expect(rendered).to include @custom_collections.first.summary[0..300]
      expect(rendered).to_not include @custom_collections.first.summary[301..-1]
      expect(rendered).to have_link 'read more'
    end
  end

  context 'for custom collecdtion whose summary is shorter than 30 characters' do

    before do
      @custom_collections = [create(:custom_collection, summary: "I am a summary")]
    end

    it 'displays the whole summary, with no "read more" link.' do
      render
      expect(rendered).to include @custom_collections.first.summary
      expect(rendered).to_not have_link 'read more'
    end
  end


end