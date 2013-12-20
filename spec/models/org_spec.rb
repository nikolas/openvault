require 'spec_helper'

describe Org do
  it 'has a valid factory' do
    build(:org).should be_valid
  end

  it 'is invalid without a name' do
    build(:org, name: nil).should_not be_valid
  end

  describe 'has many Users' do

    before :all do
      @org = create(:org)
      @users = create_list(:user, 5)
    end

    it 'handles adding multiple User to an Org' do
      @users.each { |user| @org.users << user }
      @org.users.count.should == 5
    end
  end
end