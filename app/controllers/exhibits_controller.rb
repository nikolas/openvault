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
  
end 
