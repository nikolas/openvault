require 'spec_helper'

describe Mosaic do

	   it "stores a list of items to be used for the  Mosaic" do
     	      Mosaic.create!( :slug => 'foo')
  	      Mosaic.create!( :slug => 'bar')
	      Mosaic.where( :slug => 'foo').count().should == 1
	      Mosaic.where( :slug => 'bar').count().should == 1 
	   end	   

	   
end	
