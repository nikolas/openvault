require 'exhibits_data'


class ExhibitsController < ApplicationController  

  def index
  end
  
  def rock_and_roll
    @interviews = ExhibitsData::RockAndRoll.interviews
  end
  
  def wpna
    @interviews = ExhibitsData::WPNA.interviews
    @original_footage_links = ExhibitsData::WPNA.original_footage_links
    @program_links = ExhibitsData::WPNA.program_links
    @stock_footage_links = ExhibitsData::WPNA.stock_footage_links
  end

  def vietnam
    @interviews = ExhibitsData::Vietnam.interviews
  end

  def march_on_washington
  end

  def press_and_people
  end
  
end 
