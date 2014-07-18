require 'spec_helper'

describe Org do

  describe '.random' do
    n = 3
    let!(:orgs) { create_list(:org, n) }
    
    it 'selects a random record from the database' do
      expect(orgs.count).to eq(n), "Expected #{n} records, not #{orgs.count}  (#{orgs})"
      r = Org.random
      expect(orgs).to include(r), "Expected to find id:#{r.id} name:'#{r.name}' in #{orgs}"
      # TODO: why isn't r.to_s useful?
    end
  end

  describe 'factory' do
    it 'builds a valid instance' do
      expect(build(:org)).to be_valid
    end

    it 'creates a record' do
      org = FactoryGirl.create(:org)
      org.save
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
