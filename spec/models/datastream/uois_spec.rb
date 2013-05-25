require 'spec_helper'

describe Datastream::Uois do
  let!(:valid_file) { File.open("#{fixture_path}/ingest/uois.xml") }

  subject(:uois) { Datastream::Uois.new }

  it "should accept valid UOIS xml" do
    uois.ng_xml = Nokogiri::XML(valid_file)

    uois.security_policy_uois.sec_policy_id.should == ["12"]
  end

end