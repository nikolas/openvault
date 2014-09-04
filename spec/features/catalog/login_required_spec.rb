require 'spec_helper'
require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"
#require 'openvault/pbcore'

feature "Videos from CBS" do

  before(:all) do 
    Fixtures.cwd("#{fixture_path}")
  end
  
  def setup(type, fixture_path)
    asset = type.new
    asset.pbcore.ng_xml = Fixtures.raw(fixture_path)
    asset.save!
    return asset
  end
  
  it "allowed only if logged in" do
    asset = setup(Video, "pbcore/artesia/vietnam/from_cbs.xml")
    message = 'An Open Vault account is required to watch this record'
    visit "/catalog/#{asset.pid}"
    
    expect(page).to have_content(message)
    
    user = FactoryGirl.create(:user)
    submit_login_form({email: user.email, password: user.password})
    
    expect(page).not_to have_content(message)
  end

end
