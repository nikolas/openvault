require "spec_helper"

describe "_pbcore.html.erb" do
  it "works with Programs" do
    @ov_asset = create(:program)
    @ov_asset.series = create(:series)
    render partial: "catalog/_metadata_partials/pbcore.html.erb"
  end
  
  it "works with Series" do
    @ov_asset = create(:series)
    render partial: "catalog/_metadata_partials/pbcore.html.erb"
  end
end