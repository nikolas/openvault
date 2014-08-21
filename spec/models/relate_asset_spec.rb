require 'spec_helper'

describe 'relate_asset' do

  before(:each) do
    @all = [
      @program = FactoryGirl.create(:program),
      @video = FactoryGirl.create(:video),
      @audio = FactoryGirl.create(:audio),
      @series = FactoryGirl.create(:series),
      @image = FactoryGirl.create(:image),
      @transcript = FactoryGirl.create(:transcript)
    ]
  end
  
  def has_error(expect_error, a, b)
    # All valid relationships are symmetrical.
    if expect_error
      expect {a.relate_asset b}.to raise_error, "Expected failure, but it worked: #{a.class} forward to #{b.class}"
      expect {b.relate_asset a}.to raise_error, "Expected failure, but it worked: #{b.class} back to #{a.class}"
    else 
      expect {a.relate_asset b}.not_to raise_error
      expect {b.relate_asset a}.not_to raise_error
    end
  end
  
  def has_errors(expect_error, object, relations)
    relations.each do |relation|
      has_error expect_error, object, relation
    end
  end
  
  def relates_to(object, good_relations)
    bad_relations = @all - good_relations
    has_errors false, object, good_relations
    has_errors true,  object, bad_relations
  end
  
  it Series do
    relates_to @series, [
      @program, 
      @image, # a logo?
      @audio, @video # perhaps promo materials for the series as a whole.
    ]
  end
  
  it Program do
    relates_to @program, [
      @series, # parent
      @video, @audio #, @image
      # but not transcript, which would always belong to a video or audio?
    ]
  end
  
  it Video do
    relates_to @video, [
      @series, @program, #parents
      @image, @transcript]
  end
  
  it Audio do
    relates_to @audio, [
      @series, @program, #parents 
      @transcript]
  end
  
  it Image do
    relates_to @image, [
      @series, @video #parents
      # @program, 
    ]
  end
  
  it Transcript do
    relates_to @transcript, [
      @video, @audio #parents
     ]
  end
  
end