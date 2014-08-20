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
  
  # All valid relationships are symmetrical.
  def no_error(a,b)
    expect {a.relate_asset b}.not_to raise_error
    expect {b.relate_asset a}.not_to raise_error
  end
  def yes_error(a,b)
    expect {a.relate_asset b}.to raise_error
    expect {b.relate_asset a}.to raise_error
  end
  
  def no_errors(parent,children)
    children.each do |child|
      no_error parent, child
    end
  end
  def yes_errors(parent,children)
    children.each do |child|
      yes_error parent, child
    end
  end
  
  def relates (parent, good_children)
    bad_children = @all - good_children
    no_errors parent, good_children
    yes_errors parent, bad_children
  end
  
  it Series do
    relates @series, [
      @program, 
      @image, # a logo?
      @audio, @video # perhaps promo materials for the series as a whole.
    ]
  end
  
  it Program do
    relates @program, [
      @series, # parent
      @video, @audio, @image
      # but not transcript, which would always belong to a video or audio?
    ]
  end
  
  it Video do
    relates @video, [
      @series, @program, #parents
      @image, @transcript]
  end
  
  it Audio do
    relates @audio, [
      @series, @program, #parents 
      @transcript]
  end
  
  it Image do
    relates @image, [
      @series, @program, @video #parents
    ]
  end
  
  it Transcript do
    relates @transcript, [
      @video, @audio #parents
     ]
  end
  
end