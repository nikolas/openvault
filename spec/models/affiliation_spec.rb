require 'spec_helper'

describe Affiliation do
  
  describe 'has a factory that' do
 
    let(:affiliation) { FactoryGirl.create(:affiliation) }

    it 'creates a valid affiliation (saved to db)' do
      expect(affiliation).to be_valid
      expect(Affiliation.where(title: affiliation.title).count).to eq 1
    end

    it 'builds a valid affiliation (not saved to db)' do
      unsaved_affiliation = FactoryGirl.build(:affiliation)
      expect(unsaved_affiliation).to be_valid
      expect(Affiliation.where(title: unsaved_affiliation.title).count).to eq 0
    end
  end  
end
