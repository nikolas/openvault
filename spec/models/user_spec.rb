require 'spec_helper'
require 'cancan/matchers'
require_relative '../factories/user'
require_relative '../factories/org'
require_relative '../factories/custom_collection'


describe User do

  describe "has a factory that" do

    it "creates a valid user (saved to db)" do
      saved_user = create(:user)
      saved_user.should be_valid
      User.where(:email => saved_user.email).count.should == 1
    end

    it "builds a valid user (not saved to db)" do
      unsaved_user = build(:user)
      unsaved_user.should be_valid
      User.where(:email => unsaved_user.email).count.should == 0
    end

    it 'creates a user with a slugged username field' do
      # expect(create(:user).username).to_not be_nil
      expect(FactoryGirl.create(:user).username).to_not be_nil
    end

    it "returns a hash of fields => values to simulate user input for creating a new user" do
      unsaved_user_attributes = attributes_for(:user)
      unsaved_user_attributes.should be_a Hash
      User.where(:email => unsaved_user_attributes[:email]).count.should == 0
    end
    
    # it "returns a contact's full name as a string" do
    #   saved_user = create(:user)
    # end
    it "returns the proper work_string when both title and org or present" do
      saved_user = create(:user)
      saved_user.work_string.should eq("#{saved_user.title} at #{saved_user.organization}")
    end
    
    it "returns the proper work_string when just title is present" do
      saved_user = create(:user, organization: nil)
      saved_user.work_string.should eq("#{saved_user.title}")
    end
    
    it "returns the proper work_string when just org is present" do
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
   
    before(:all) do
      @user = FactoryGirl.create(:user)
      @custom_collections = FactoryGirl.create_list(:custom_collection, 5)
    end
    
    it "should handle adding multiple CustomCollections to a User" do
      @custom_collections.each { |cc| @user.collab_collections << cc }
      @user.collab_collections.count.should == 5
    end
    
  end

  describe "has many Orgs" do
    before :all do
      @user = FactoryGirl.create(:user)
      @orgs = FactoryGirl.create_list(:org, 5)
    end

    it 'should handle adding multiple Orgs to a User' do
      @orgs.each { |org| @user.orgs << org }
      @user.orgs.count.should == 5
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

      it { should be_able_to(:index, custom_collection) }
      it { should be_able_to(:show, custom_collection) }
      it { should_not be_able_to(:create, custom_collection) }
      it { should_not be_able_to(:destroy, custom_collection) }
      it { should_not be_able_to(:update, custom_collection) }
      it { should_not be_able_to(:add_item, custom_collection) }
      it { should_not be_able_to(:remove_item, custom_collection) }

    end

    context "when they own the collection" do

      let(:user) { create(:user, role: 'scholar') }
      let(:custom_collection) { create(:custom_collection, owner: user) }

      subject { Ability.new(user) }

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