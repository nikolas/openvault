require 'spec_helper'

describe CustomCollection do

  describe 'factory :custom_collection' do
    it 'can build a valid instance' do
      build(:custom_collection).should be_valid
    end

    it 'can create a valid instance' do
      cc = FactoryGirl.create(:custom_collection).tap { |obj| obj.save } # TODO: chaining #save! should not be required, but it is.
      expect(cc.new_record?).to be false
    end

    describe ':with_items' do
      it 'creates an instance with associated CustomCollectionItems, 2 by default.' do
        expect(create(:custom_collection, :with_items).custom_collection_items.count).to eq 2
      end

      it 'creates an instance with N associated CustomCollectionItems, where :num_items => N' do
        num_items = rand 3
        expect(create(:custom_collection, :with_items, num_items: num_items).custom_collection_items.count).to eq num_items
      end
    end

    describe ':with_collabs' do
      it 'creates an instance with assocated Users, 2 by default' do
        expect(create(:custom_collection, :with_collabs).collabs.count).to eq 2
      end

      it 'creates an instance with N associated Users, where :num_collabs => N' do
        num_collabs = rand 3
        expect(create(:custom_collection, :with_collabs, num_collabs: num_collabs).collabs.count).to eq num_collabs
      end
    end
  end

  it 'is invalid without an owner' do
    build(:custom_collection, owner: nil).should_not be_valid
  end

  it 'is valid if owner is a User who is a scholar' do
    build(:custom_collection, owner: build(:user, role: "scholar")).should be_valid
  end

  it 'is valid if owner is an Org' do
    build(:custom_collection, owner: build(:org)).should be_valid
  end

  it 'is invalid if User is not a scholar' do
    build(:custom_collection, owner: build(:user, role: "member")).should_not be_valid
  end

  it "is invalid without a name" do
    build(:custom_collection, name: nil).should_not be_valid
  end

  it "is invalid without a summary"  do
    build(:custom_collection, summary: nil).should_not be_valid
  end

  pending "has a valid vanity url" do
    # I scrapped this for now because I don't think that URL logic should go in the model,
    # but not sure how to implement it at the moment.
    # user = create(:user, first_name: 'John', last_name: 'Smith', role: 'scholar')
    # collection = create(:custom_collection, name: 'testing 1', owner: user)
    # collection.vanity_url.should eq("/scholar/john-smith/testing-1")
    fail
  end
end
