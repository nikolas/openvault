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

  let(:builder) { Openvault::Pbcore::AssetRelationshipBuilder.new(@program) }

  describe '#assets_related_through_pbcore' do
    it 'checks pbcore metadata for associations with other assets, and returns Fedora objects for those assets' do
      expect(builder.assets_related_through_pbcore).to eq [@video]
    end
  end

  describe '#establish_relationships_in_fedora' do
    it 'establishes relationshps between fedora objects that have been identified from pbcore metadata.' do
      builder.establish_relationships_in_fedora
      expect(@program.videos).to eq [@video]
      # TODO: @video.program doesn't work here b/c @video does not get reloaded, and not sure how to do it.
      expect(@program.videos.first.program).to eq @program
    end
  end

  describe '#relate' do

    let(:series) { Series.new }
    let(:program) { Program.new }
    let(:video) { Video.new }
    let(:audio) { Audio.new }
    let(:image) { Image.new }
    let(:transcript) { Transcript.new }

    let(:builder) { Openvault::Pbcore::AssetRelationshipBuilder.new(subject) }
    
    context 'when #asset is a Series' do

      subject { series }

      it 'relates a Program' do
        builder.relate program
        expect(builder.asset.programs).to eq [program]
      end

      it 'relates a Video' do
        builder.relate video
        expect(builder.asset.videos).to eq [video]
      end

      it 'relates an Audio' do
        builder.relate audio
        expect(builder.asset.audios).to eq [audio]
      end

      it 'relates an Image' do
        builder.relate image
        expect(builder.asset.images).to eq [image]
      end

    end

    context 'when #asset is a Program' do

      subject { program }

      it 'relates a Series' do
        builder.relate series
        expect(builder.asset.series).to eq series
      end

      it 'relates a Video' do
        builder.relate video
        expect(builder.asset.videos).to eq [video]
      end

      it 'relates an Audio' do
        builder.relate audio
        expect(builder.asset.audios).to eq [audio]
      end

      it 'relates an Image' do
        builder.relate image
        expect(builder.asset.images).to eq [image]
      end

      it 'relates an Transcript' do
        builder.relate transcript
        expect(builder.asset.transcripts).to eq [transcript]
      end

    end

    context 'when #asset is a Video' do

      subject { video }

      it 'relates a Series' do
        builder.relate series
        expect(builder.asset.series).to eq series
      end

      it 'relates a Program' do
        builder.relate program
        expect(builder.asset.program).to eq program
      end

      it 'relates an Image' do
        builder.relate image
        expect(builder.asset.images).to eq [image]
      end

      it 'relates an Transcript' do
        builder.relate transcript
        expect(builder.asset.transcripts).to eq [transcript]
      end

    end

    context 'when #asset is an Audio' do

      subject { audio }

      it 'relates a Series' do
        builder.relate series
        expect(builder.asset.series).to eq series
      end

      it 'relates a Program' do
        builder.relate program
        expect(builder.asset.program).to eq program
      end

      it 'relates an Image' do
        builder.relate image
        expect(builder.asset.images).to eq [image]
      end

      it 'relates an Transcript' do
        builder.relate transcript
        expect(builder.asset.transcripts).to eq [transcript]
      end

    end

    context 'when #asset is an Image' do

      subject { image }

      it 'relates a Series' do
        builder.relate series
        expect(builder.asset.series).to eq series
      end

      it 'relates a Program' do
        builder.relate program
        expect(builder.asset.program).to eq program
      end

      it 'relates a Video' do
        builder.relate video
        expect(builder.asset.video).to eq video
      end

    end

    context 'when #asset is an Transcript' do

      subject { transcript }

      it 'relates a Audio' do
        builder.relate audio
        expect(builder.asset.audio).to eq audio
      end

      it 'relates a Program' do
        builder.relate program
        expect(builder.asset.program).to eq program
      end

      it 'relates a Video' do
        builder.relate video
        expect(builder.asset.video).to eq video
      end

    end

    it 'raises an UnhandledRelationType exception when the the the AssetRelationshipBuilder does not know how to establish the relationship.' do
      builder = Openvault::Pbcore::AssetRelationshipBuilder.new(series)
      expect{ builder.relate transcript }.to raise_error Openvault::Pbcore::AssetRelationshipBuilder::UnhandledRelationType
    end





  end

end
