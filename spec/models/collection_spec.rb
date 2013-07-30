require 'spec_helper'

describe Collection do
  before :each do
    @collection = build(:collection)
  end
  it "is valid with valid parameters" do
    @collection.should be_valid
  end
  
  it "is invalid without a name" do
    @collection.name = nil
    @collection.should_not be_valid
  end
  
  it "is invalid without a summary" do
    @collection.summary = nil
    @collection.should_not be_valid
  end
  
  it "is invalid with a duplicate name" do
    @c1 = create(:collection, name: "Testing Name")
    @c2 = build(:collection, name: "Testing Name")
    @c2.should_not be_valid
  end
  
  it "has a valid slug after save" do
    @collection.name = 'Testing 1'
    @collection.save
    @collection.slug.should eq("testing-1")
  end
  
end
