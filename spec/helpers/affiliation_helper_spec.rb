require 'spec_helper' 
require 'affiliations_helper'
include AffiliationsHelper
describe 'user work string' do

  it "returns the proper work_string when both title and org or present" do
    affiliation = FactoryGirl.create(:affiliation, primary: true)
    user = affiliation.user
    expect(work_string(user)).to eq("#{user.primary_title} at #{user.primary_organization}")
  end

  it "returns the proper work_string when just org is present" do
    affiliation = FactoryGirl.create(:affiliation, primary: true, title: nil)
    user = affiliation.user
    expect(work_string(user)).to eq("works at #{user.primary_organization}")
  end

  it "raises exception when just title is present" do
    affiliation = FactoryGirl.create(:affiliation, primary: true, org: nil)
    user = affiliation.user
    expect{work_string(user)}.to raise_error("User must have an organization to have a title.")
  end
end
