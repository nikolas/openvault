Fixtures.cwd File.expand_path('../', __FILE__)

# Load PBCore xml fixtures
Fixtures.load([
  "mars/program_1.xml"
]) do |fixture|
  ov = OpenvaultAsset.new
  ov.pbcore.ng_xml = Openvault::XML(fixture.raw)
  ov
end

Fixtures.load('mars/programs_1.xml')