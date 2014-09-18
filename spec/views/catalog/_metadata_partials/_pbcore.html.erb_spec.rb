require "spec_helper"

describe "_pbcore.html.erb" do
  it "works with Videos" do
    @ov_asset = create(:video)
    @ov_asset.program = create(:program)
    @ov_asset.series = create(:series)
    render partial: "catalog/_metadata_partials/pbcore"
    expect(rendered).to include @ov_asset.program.title
    expect(rendered).to include @ov_asset.series.title
  end
  
  it "works with Programs" do
    @ov_asset = create(:program)
    @ov_asset.series = create(:series)
    render partial: "catalog/_metadata_partials/pbcore"
    expect(rendered).to include @ov_asset.series.title 
  end
  
  it "works with Series" do
    @ov_asset = create(:series)
    expect {render partial: "catalog/_metadata_partials/pbcore"}.not_to raise_error
  end
  
  it "works with nils" do
    # Not really sure why sometimes the method doesn't exist,
    # and other times the method exists but returns nil, but we should check both.
    @ov_asset = create(:video)
    @ov_asset.program = nil
    @ov_asset.series = nil
    expect {render partial: "catalog/_metadata_partials/pbcore"}.not_to raise_error
  end
end