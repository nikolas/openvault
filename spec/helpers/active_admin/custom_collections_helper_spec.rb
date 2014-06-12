require 'spec_helper'

describe ActiveAdmin::CustomCollectionsHelper do

  before(:context) do
    create_list(:scholar_user, 3)
    create_list(:org, 3)
  end

  describe '#scholar_owner_options' do

    let(:options) { scholar_owner_options }

    it 'contains an entry for each User who is a "scholar"' do
      expect(options.count).to eq User.scholars.count
    end

    it 'has "User:###" as the second value of each options, where "###" is the ID of the scholar' do
      options.each do |option|
        expect(option.last).to match(/^User:\d+$/)
      end
    end
  end

  describe '#org_owner_options' do

    let(:options) { org_owner_options }

    it 'conatins an entry for each Org' do
      expect(org_owner_options.count).to eq Org.count
    end

    it 'has "Org:###" as the second value of each options, where "###" is the ID of the organization' do
      options.each do |option|
        expect(option.last).to match(/^Org:\d+$/)
      end
    end
  end

end