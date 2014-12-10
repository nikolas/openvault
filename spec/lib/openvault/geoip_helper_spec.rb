require 'spec_helper'
require 'openvault/geoip_helper'

describe Openvault::GeoipHelper do

  def expect_ip(ip, country_code)
    expect(Openvault::GeoipHelper.get_country_code_for_ip(ip)).to eq(country_code)
  end

  # Used 'dig' to get IPs for hostnames.
  
  it '8.8.8.8' do
    expect_ip('8.8.8.8', 'US')
  end
  
  it 'localhost' do
    expect_ip('127.0.0.1', nil)
  end
  
  it 'canada.ca' do
    expect_ip('205.193.215.2', 'CA')
  end
  
  xit 'gov.uk (returns "US": CDN)' do
    expect_ip('104.16.25.49', 'GB') 
  end
  
  it 'scotland.gov.uk' do
    expect_ip('134.19.161.249', 'GB')
  end
  
  it 'northernireland.gov.uk' do
    expect_ip('145.229.156.226', 'GB')
  end
  
  it 'gov.ie' do
    expect_ip('54.155.150.58', 'IE')
  end
  
  xit 'gouvernement.fr (returns "IE": CDN)' do
    expect_ip('54.155.150.58', 'FR')
  end
  
end