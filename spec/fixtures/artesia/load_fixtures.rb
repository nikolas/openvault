require 'openvault'
require 'artesia/datastream/uois'
require 'artesia/datastream/teams_asset_file'

Fixtures.cwd File.expand_path('../', __FILE__)

# Load TEAMS_ASSET_FILE fixtures.
Fixtures.load([
  "rock_and_roll/teams_asset_file.xml",
  "zoom/teams_asset_file.xml",
  "march_on_washington/teams_asset_file.xml",
  "patriots_day/teams_asset_file.xml"
]) do |fixture|
  teams_asset_file = Artesia::Datastream::TeamsAssetFile.new
  teams_asset_file.ng_xml = Openvault::XML(fixture.raw)
  teams_asset_file
end


# Load UOIS fixtures
Fixtures.load([

  # generic
  "generic/wgbh_titles.xml",
  "generic/wgbh_creators.xml",
  "generic/wgbh_subjects.xml",

  # rock and roll UOIS
  "rock_and_roll/series_1.xml",
  "rock_and_roll/program_1.xml",
  "rock_and_roll/video_1.xml",
  "rock_and_roll/video_2.xml",
  "rock_and_roll/video_3.xml",
  "rock_and_roll/image_1.xml",
  "rock_and_roll/image_2.xml",
  "rock_and_roll/transcript_1.xml",

  # zoom UOIS
  "zoom/series_1.xml",
  "zoom/program_1.xml",
  "zoom/video_1.xml",
  "zoom/video_2.xml",
  "zoom/video_3.xml",
  "zoom/image_1.xml",

  # march on washington UOIS
  "march_on_washington/audio_1.xml",

  # patriot's day
  'patriots_day/collection_1.xml',
  'patriots_day/video_1.xml',
  'patriots_day/video_2.xml',
  "patriots_day/audio_1.xml",
  "patriots_day/audio_2.xml",
  "patriots_day/image_1.xml",
  "patriots_day/image_2.xml",
  "patriots_day/image_3.xml"

]) do |fixture|
  uois = Artesia::Datastream::UOIS.new
  uois.ng_xml = Openvault::XML(fixture.raw)
  uois
end
