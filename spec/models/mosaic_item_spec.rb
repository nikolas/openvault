require 'spec_helper'

describe MosaicItem do
  
  it "stores a list of items to be used for the  Mosaic" do
    MosaicItem.create!( :slug => 'foo')
    MosaicItem.create!( :slug => 'bar')
    MosaicItem.where( :slug => 'foo').count().should == 1
    MosaicItem.where( :slug => 'bar').count().should == 1 
  end	   
  	   
end	

