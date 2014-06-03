require 'spec_helper'

require_relative '../factories/transcript'

describe Transcript do

  describe 'factory' do
    it 'builds an unsaved instance' do
      t = build(:transcript)
      expect(t).to be_a Transcript
      expect(t.new_record?).to be_true
    end

    it 'creates a saved instance' do
      t = create(:transcript)
      expect(t).to be_a Transcript
      expect(t.new_record?).to be_false
    end
  end

  describe '#tei' do
    it 'returns a datastream' do
      expect(build(:transcript).tei).to be_a ActiveFedora::Datastream
    end

    describe '.content=' do
      it 'can be assigned '
    end
  end
end
