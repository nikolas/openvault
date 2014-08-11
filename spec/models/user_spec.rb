require 'spec_helper'
require 'cancan/matchers'

describe User do

  describe '.random' do
    let!(:users) { create_list(:user, 3) }
    it 'selects a random user from the database' do
      expect(User.all).to include(User.random)
    end
  end

  describe "has a factory that" do
    
    let(:user) { FactoryGirl.create(:user) }
    
    it "creates a valid user (saved to db)" do
      expect(user).to be_valid
      expect(User.where(:email => user.email).count).to eq 1
    end

    it "builds a valid user (not saved to db)" do
      unsaved_user = FactoryGirl.build(:user)
      unsaved_user.should be_valid
      User.where(:email => unsaved_user.email).count.should == 0
    end

    it 'creates a user with a slugged username field' do
      expect(FactoryGirl.create(:user).tap {|u| u.save }.username).to_not be nil
    end

    it "returns a hash of fields => values to simulate user input for creating a new user" do
      unsaved_user_attributes = attributes_for(:user)
      unsaved_user_attributes.should be_a Hash
      User.where(:email => unsaved_user_attributes[:email]).count.should == 0
    end

    pending "returns the proper work_string when both title and org or present" do
      saved_user = create(:user)
      saved_user.work_string.should eq("#{saved_user.title} at #{saved_user.organization}")
    end

    pending "returns the proper work_string when just org is present" do
      saved_user = create(:user, title: nil)
      saved_user.work_string.should eq("works at #{saved_user.organization}")
    end

    it "fails to save when user bio is greater than 5000 characters" do
      bio = Array.new(5001, 'x').join
      unsaved_user = build(:user, bio: bio)
      unsaved_user.should_not be_valid
    end

  end

  describe "has many CustomCollections" do

    let(:user) { FactoryGirl.create(:user) }
    let(:custom_collections) { FactoryGirl.create_list(:custom_collection, 5) }

    it "should handle adding multiple CustomCollections to a User" do
      expect {
        custom_collections.each { |cc| user.collab_collections << cc }
        user.save
      }.to change(user.collab_collections, :count).by custom_collections.length
    end

  end

  describe "has many Orgs" do
    let(:user) { FactoryGirl.create(:user) }
    let(:orgs) { FactoryGirl.create_list(:org, 5) }

    it 'should handle adding multiple Orgs to a User' do
      expect {
        orgs.each { |org| user.orgs << org }
        user.save
      }.to change(user.orgs, :count).by orgs.length
    end
  end


  describe "abilities" do

    context "when they are a \"scholar\"" do

      let(:user) { create(:user, role: 'scholar') }

      subject { Ability.new(user) }

      it { should be_able_to(:index, CustomCollection) }
      it { should be_able_to(:show, CustomCollection) }
      it { should be_able_to(:create, CustomCollection) }
      it { should_not be_able_to(:destroy, CustomCollection) }
    end

    context "when they are not a scholar" do

      let(:user) { create(:user, role: 'scholar') }
      let(:custom_collection) { create(:custom_collection, owner: user) }
      let(:user2)  { create(:user, role: "member") }
      subject { Ability.new(user2) }

      before(:each) { user.save and custom_collection.save and user2.save }

      it { should be_able_to(:index, custom_collection) }
      it { should be_able_to(:show, custom_collection) }
      it { should_not be_able_to(:create, custom_collection) }
      it { should_not be_able_to(:destroy, custom_collection) }
      it { should_not be_able_to(:update, custom_collection) }
      it { should_not be_able_to(:add_item, custom_collection) }
      it { should_not be_able_to(:remove_item, custom_collection) }

    end

    context "when they own the collection" do

      let(:user) { FactoryGirl.create(:user_with_custom_collection) }
      let(:custom_collection) { user.owned_collections.first }
      subject { Ability.new(user) }
      before(:each) { user.save }

      it { should be_able_to(:update, custom_collection) }
      it { should be_able_to(:add_item, custom_collection) }
      it { should be_able_to(:remove_item, custom_collection) }
    end

    context "when they do not own the collection" do

      let(:user) { create(:user, role: 'scholar') }
      let(:custom_collection) { create(:custom_collection) }

      subject { Ability.new(user) }

      it { should_not be_able_to(:update, custom_collection) }
      it { should_not be_able_to(:add_item, custom_collection) }
      it { should_not be_able_to(:remove_item, custom_collection) }
    end


  end


end
