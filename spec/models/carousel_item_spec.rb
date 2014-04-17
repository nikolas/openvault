require 'spec_helper'

describe CarouselItem do
  before :each do
    @carousel_item = build(:carousel_item)
  end

  it "is valid with valid parameters" do
    @carousel_item.should be_valid
  end
  
  it "is invalid without a title" do
    @carousel_item.title = nil
    @carousel_item.should_not be_valid
  end
  
  it "is invalid without a body" do
    @carousel_item.body = nil
    @carousel_item.should_not be_valid
  end
  
  it "is invalid without a position" do
    @carousel_item.position = nil
    @carousel_item.should_not be_valid
  end
end
