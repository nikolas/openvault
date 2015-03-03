require 'spec_helper'
require 'openvault'

describe "visiting override page", type: :feature do
  it "non-existent returns 404" do
    visit "/some/crazy/url.xml"
    expect(page.status_code).to eq(404)
  end
end
