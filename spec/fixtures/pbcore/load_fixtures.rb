Fixtures.cwd File.expand_path('../', __FILE__)

# Load PBCore xml fixtures
Fixtures.load([
  "mars/program_1.xml"
]) do |fixture|
  pbcore = HydraPbcore::Datastream::Document.new
  pbcore.ng_xml = Openvault::XML(fixture.raw)
  pbcore
end

Fixtures.load('mars/programs_1.xml')