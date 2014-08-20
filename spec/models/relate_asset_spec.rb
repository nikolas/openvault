require 'spec_helper'

describe 'relate_asset' do

  before(:each) do
    @program = FactoryGirl.create :program
    @video = FactoryGirl.create :video
    @audio = FactoryGirl.create :audio
    @series = FactoryGirl.create :series
  end
  
  def no_error(a,b)
    expect {a.relate_asset b}.not_to raise_error
  end
  
  describe Program do
    it 'relates well' do
      no_error @program, @video
      no_error @program, @audio
      no_error @program, @series
    end
  end
  
end