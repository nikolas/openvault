require 'spec_helper'

describe CarouselItem do
  describe 'factory' do
    it 'builds a valid instance' do
      expect(build(:carousel_item)).to be_valid
    end

    it 'creates a record' do
      carousel_item = create(:carousel_item).tap { |item| item.save }
      expect(carousel_item.new_record?).to be false
    end
  end


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
