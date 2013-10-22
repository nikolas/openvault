Fixtures.cwd File.expand_path('../', __FILE__)

# Load MARS xml. This is what is exported from Filemaker
Fixtures.load([
  "asset_1.xml"
])

# Load MARS xml that has been converted to PBCore as a HydraPbcore::Datastream::Document instances.
# NOTE: The raw xml can still be accessed, e.g. Fixtures.use('to_pbcore/asset_1.xml').raw
Fixtures.load([
  "as_pbcore/asset_1.xml"
]) do |fixture|
  pbcore = PbcoreDescDoc.new
  pbcore.ng_xml = Openvault::XML(fixture.raw)
  pbcore
end