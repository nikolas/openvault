Fixtures.cwd File.expand_path('../', __FILE__)

# Load PBCore xml fixtures
Fixtures.load(
  Dir['spec/fixtures/pbcore/**/*.xml'].map{|path| path.sub!('spec/fixtures/pbcore/', '')}
) do |fixture|

  # For each of the files loaded, use Nokogiri to grab the first <pbcoreDescriptionDocument> node (should only be one)
  # and assign it to the ng_xml object of the PbcoreDescDoc instance.
  pbcore_ds = PbcoreDescDoc.new
  ng_xml = Openvault::XML fixture.raw
  ng_xml.remove_namespaces!
  ng_doc = ng_xml.xpath('//pbcoreDescriptionDocument').first
  pbcore_ds.ng_xml = ng_doc
  pbcore_ds
end

Fixtures.load('mars/programs_1.xml')

# Empty samples for testing ability to ingest standalone pbcoreDescriptionDocument nodes
# as well as pbcoreDescriptionDocument nodes nested inside of pbcoreCollection nodes.
Fixtures.load([
  'pbcore_collection_empty_docs_1x.xml',
  'pbcore_collection_empty_docs_2x.xml',
  'pbcore_desc_doc_empty.xml'
])

Fixtures.load('artesia/rock_and_roll/related_assets_subset.xml')

# Tei fixtures
Fixtures.cwd('spec/fixtures')
Fixtures.load(['tei/Patriots_Day_tei.xml',
  'tei/Joyce_Chen_log_without_speaker.xml',
  'tei/Joyce_Chen_log_with_speaker.xml'
])

