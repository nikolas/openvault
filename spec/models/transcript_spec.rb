require 'spec_helper'

describe Transcript do

  describe 'factory' do
    it 'builds an unsaved instance' do
      t = build(:transcript)
      expect(t).to be_valid
      expect(t.new_record?).to eq true
    end

    it 'creates a saved instance' do
      t = create(:transcript)
      expect(t.new_record?).to eq false
    end
  end

  describe '#tei' do
    it 'returns the TeiDatastream containing TEI XML' do
      expect(build(:transcript).tei).to be_a TeiDatastream
    end
  end
end
