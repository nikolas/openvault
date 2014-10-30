require 'spec_helper'
require 'openvault/pbcore'
# require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

# RSpec::Matchers.define :be_associated_with do |*expected|
#   match do |actual|
#     false
#   end
# end

describe Openvault::Pbcore::AssetRelationshipBuilder do

  # describe '#pbcore_relation_identifiers' do
  #   it 'returns the values of pbcoreRelationIdentifiers'
  # end

  # describe '#assets_related_through_metadata' do
  #   it "looks for existing Fedora objects that have been indexed with pbcoreIdentifier values that match the " do
  #     expect(asset_1.)
  #   end
  # end


  # Use let! here to ensure the objects arr put into Fedora right away
  before :all do

    @program_pbcore =  create(
      :pbcore_desc_doc,
      ids: '111',
      relations: [
        {id: '222'}
      ]
    )

    @video_pbcore = create(
      :pbcore_desc_doc,
      ids: '222',
      relations: [
        {id: '111'}
      ]
    )

    @program = create(:program, pbcore: @program_pbcore)
    @video = create(:video, pbcore: @video_pbcore)
  end

  after(:all) do
    @program.delete
    @video.delete
  end

  let(:relationship_builder) { Openvault::Pbcore::AssetRelationshipBuilder.new(@program) }

  describe '#assets_related_through_pbcore' do
    it 'checks pbcore metadata for associations with other assets, and returns Fedora objects for those assets' do
      expect(relationship_builder.assets_related_through_pbcore).to eq [@video]
    end
  end

  describe '#establish_relationships_in_fedora' do
    it 'establishes relationshps between fedora objects that have been identified from pbcore metadata.' do
      relationship_builder.establish_relationships_in_fedora
      expect(@program.videos).to eq [@video]
      # TODO: @video.program doesn't work here b/c @video does not get reloaded, and not sure how to do it.
      expect(@program.videos.first.program).to eq @program
    end
  end

end
