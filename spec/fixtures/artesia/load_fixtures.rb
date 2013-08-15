def teams_asset_file_from_fixture(file)
  xml = File.read(file)
  teams_asset_file = Artesia::Datastream::TeamsAssetFile.new
  teams_asset_file.ng_xml = Openvault::XML(xml)
  teams_asset_file
end

def uois_from_fixture(file)
  xml = File.read(file)
  uois = Artesia::Datastream::UOIS.new
  uois.ng_xml = Openvault::XML(xml)
  uois
end



Fixtures[:artesia] ||= {}
Fixtures[:artesia].deep_merge!({
  :rock_and_roll => {
    :teams_asset_file => teams_asset_file_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/teams_asset_file.xml"),
    :series_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/series_1.xml"),
    :program_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/program_1.xml"),
    :video_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/video_1.xml"),
    :video_2 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/video_2.xml"),
    :video_3 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/video_3.xml"),
    :image_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/image_1.xml"),
    :image_2 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/image_2.xml"),      
    :transcript_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/rock_and_roll/transcript_1.xml")
  },

  :zoom => {
    :teams_asset_file => teams_asset_file_from_fixture("#{Fixtures.base_dir}/artesia/zoom/teams_asset_file.xml"),
    :series_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/series_1.xml"),
    :program_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/program_1.xml"),
    :video_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/video_1.xml"),
    :video_2 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/video_2.xml"),
    :video_3 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/video_3.xml"),
    :image_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/zoom/image_1.xml")
  },

  :march_on_washington => {
    :teams_asset_file => teams_asset_file_from_fixture("#{Fixtures.base_dir}/artesia/march_on_washington/teams_asset_file.xml"),
    :audio_1 => uois_from_fixture("#{Fixtures.base_dir}/artesia/march_on_washington/audio_1.xml")
  },

  :patriots_day => {
    :teams_asset_file => teams_asset_file_from_fixture("#{Fixtures.base_dir}/artesia/patriots_day/teams_asset_file.xml")
  }
})