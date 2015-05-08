require 'exhibits_data'


class ExhibitsController < ApplicationController  

  def index
  end

  def advocates
    @full_program_links = ExhibitsData::Advocates.full_program_links
  end
  
  def rock_and_roll
    @interviews = ExhibitsData::RockAndRoll.interviews
    @program_links = ExhibitsData::RockAndRoll.program_links
  end
  
  def wpna
    @interviews = ExhibitsData::WPNA.interviews
    @original_footage_links = ExhibitsData::WPNA.original_footage_links
    @program_links = ExhibitsData::WPNA.program_links
    @stock_footage_links = ExhibitsData::WPNA.stock_footage_links
  end

  def vietnam
    @interviews = ExhibitsData::Vietnam.interviews
    @original_footage_links = ExhibitsData::Vietnam.original_footage_links
    @archival_footage_links = ExhibitsData::Vietnam.archival_footage_links
    @photograph_links = ExhibitsData::Vietnam.photograph_links
  end

  def march_on_washington
    @ern_coverage_links = ExhibitsData::MarchOnWashington.ern_coverage_links
    @revisiting_mow_links = ExhibitsData::MarchOnWashington.revisiting_mow_links
    @photograph_links = ExhibitsData::MarchOnWashington.photograph_links
  end

  def press_and_people
    @full_program_video_links = ExhibitsData::PressAndPeople.full_program_video_links
  end

  def from_the_vault
    @video_links = ExhibitsData::FromTheVault.video_links
  end

  def say_brother
    @complete_collection_links = ExhibitsData::SayBrother.complete_collection_links
    @civil_rights_collection_links = ExhibitsData::SayBrother.civil_rights_collection_links
    @music_performances_links = ExhibitsData::SayBrother.music_performances_links
  end

  def new_television_workshop
    @complete_collection_links = ExhibitsData::NewTelevisionWorkshop.complete_collection_links
    @artists_showcase_links = ExhibitsData::NewTelevisionWorkshop.artists_showcase_links
    @frames_of_reference_links = ExhibitsData::NewTelevisionWorkshop.frames_of_reference_links
  end
  
end 
