require "spec_helper"

describe "_pbcore.html.erb" do
  it "works with Programs" do
    @ov_asset = create(:program)
    render :partial => "catalog/_metadata_partials/pbcore.html.erb"
  end
end