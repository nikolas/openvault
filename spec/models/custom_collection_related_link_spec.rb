require 'spec_helper'

describe CustomCollectionRelatedLink do
  it "has a valid factory" do
    expect(create(:custom_collection_related_link)).to be_valid
  end
  
  it "is invalid without a link" do
    expect(build(:custom_collection_related_link, link: nil)).to_not be_valid
  end
  
  it "is invalid without a valid url" do
    expect(build(:custom_collection_related_link, link: 'asdfasdf')).to_not be_valid
  end
  
  it "is invalid without a desc" do
    expect(build(:custom_collection_related_link, desc: nil)).to_not be_valid
  end
  
  it "is invalid without a custom_collection" do
    expect(build(:custom_collection_related_link, custom_collection_id: nil)).to_not be_valid
  end
  
end
