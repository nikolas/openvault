require 'spec_helper'

describe Org do

  describe '.random' do
    it 'selects a random record from the database' do
      create_list(:org, 3)
      expect(Org.all).to include Org.random
    end
  end

  describe 'factory' do
    it 'builds a valid instance' do
      expect(build(:org)).to be_valid
    end

    it 'creates a record' do
      org = FactoryGirl.create(:org)
      expect(org.new_record?).to be false
    end
  end

  it 'is invalid without a name' do
    build(:org, name: nil).should_not be_valid
  end

  describe 'has many Users' do
    let(:org) { FactoryGirl.create(:org)}
    let(:users) { FactoryGirl.create_list(:user, 5) }

    it 'handles adding multiple User to an Org' do
      expect {
        users.each { |user| org.users << user }
        org.save
      }.to change(org.users, :count).by users.count
    end
  end
end
