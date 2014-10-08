Fixtures.cwd File.expand_path('../', __FILE__)

# Load PBCore xml fixtures
Fixtures.load([
  "mars/series_1.xml",
  "mars/program_1.xml",
  "mars/image_1.xml",
  "mars/image_2.xml",
  "mars/video_1.xml",
  "mars/audio_1.xml",

  "artesia/rock_and_roll/series_1.xml",
  "artesia/rock_and_roll/program_1.xml",
  "artesia/rock_and_roll/video_1.xml",
  "artesia/rock_and_roll/video_2.xml",
  "artesia/rock_and_roll/video_3.xml",
  "artesia/rock_and_roll/transcript_1.xml",
  "artesia/rock_and_roll/transcript_2.xml",
  "artesia/rock_and_roll/image_1.xml",

  "artesia/march_on_washington/audio_1.xml",
  "artesia/march_on_washington/image_1.xml",

  "artesia/patriots_day/audio_3.xml",
  "artesia/patriots_day/video_1.xml",
  "artesia/patriots_day/video_2.xml",
  "artesia/patriots_day/video_3.xml",
  "artesia/patriots_day/image_2.xml",
  "artesia/patriots_day/audio_1.xml",
  "artesia/patriots_day/audio_2.xml",
  "artesia/patriots_day/transcript_1.xml",

  "artesia/joyce_chen/multiple_models.xml",
  "artesia/joyce_chen/image_1.xml",
  
  "artesia/vietnam/from_cbs.xml",
  "artesia/vietnam/video_1.xml",
  
  "artesia/war_and_peace/image_1.xml",
  "artesia/war_and_peace/transcript_1.xml",
  
  'pbcore_rights.xml',
  'pbcore_media.xml',
  'pbcore_contributors.xml',
  'pbcore_subject.xml'
]) do |fixture|

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

