require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe '#cite' do

  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

  subject(:video) {
    Video.new.tap{|video| 
      video.pbcore.ng_xml = Fixtures.use('artesia/march_on_washington/audio_1.xml').ng_xml
      video.define_singleton_method(:id) {
        'FAKE_ID'
      }
    }
  }
  
  subject(:today) {
    Time.now.strftime("%B %e, %Y")
  }
  
  it ':chicago works' do
    expect(video.cite(:chicago)).to eq("\"Radio program (Master),\" 04/29/2011, WGBH Media Library & Archives, accessed #{today}, http://openvault.wgbh.org/catalog/FAKE_ID.")
  end
  
  it ':mla works' do
    expect(video.cite(:mla)).to eq("\"Radio program (Master).\" 04/29/2011. WGBH Media Library & Archives. Web. #{today}. <http://openvault.wgbh.org/catalog/FAKE_ID>.")
  end
  
  it ':apa works' do
    expect(video.cite(:apa)).to eq("Radio program (Master). Boston, MA: WGBH Media Library & Archives. Retrieved from http://openvault.wgbh.org/catalog/FAKE_ID")
  end
  
end