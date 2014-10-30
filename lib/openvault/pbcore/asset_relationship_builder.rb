module Openvault::Pbcore
  class AssetRelationshipBuilder
    attr_accessor :asset

    def initialize(asset=nil)
      @asset = asset
    end

    def pbcore
      asset.pbcore
    end

    # Uses pbcore.relations_by_type to establish ActiveFedora relations with existing fedora objects.
    # NOTE: This method assumes:
    #   * Two records are related when a value within one record's <pbcoreIdentifier> node is present in another's <pbcoreRelationIdentifier> node
    #   * There is only one <pbcoreRelationIdentifier> per <pbcoreRelation>
    def establish_relationships_in_fedora
      assets_related_through_pbcore.each do |related_asset|
        relate related_asset
        asset.save!
      end
    end

    def assets_related_through_pbcore
      related = []
      pbcore.relations_by_type.each do |relation_type, pbcore_ids|
        pbcore_ids.each do |pbcore_id|
          related += ActiveFedora::Base.find({:all_ids_tesim => pbcore_id})
        end
      end
      related
    end


    def relate(target_asset)

      case asset

      when Series
        case target_asset
        when Program
          asset.programs << target_asset
        when Video
          asset.videos << target_asset
        when Audio
          asset.audios << target_asset
        when Image
          asset.images << target_asset
        else
          raise UnhandledRelationType
        end


      when Program
        case target_asset
        when Series
          asset.series = target_asset
        when Video
          asset.videos << target_asset
        when Audio
          asset.audios << target_asset
        when Image
          asset.images << target_asset
        when Transcript
          asset.transcripts << target_asset
        else
          raise UnhandledRelationType
        end

      when Video
        case target_asset
        when Series
          asset.series = target_asset
        when Program
          asset.program = target_asset
        when Image
          asset.images << target_asset
        when Transcript
          asset.transcripts << target_asset
        else
          raise UnhandledRelationType
        end

      when Image
        case target_asset
        when Video
          asset.video = target_asset
        when Program
          asset.program = target_asset
        when Series
          asset.series = target_asset
        else
          raise UnhandledRelationType
        end


      when Audio
        case target_asset
        when Series
          asset.series = target_asset
        when Program
          asset.program = target_asset
        when Transcript
          asset.transcripts << target_asset
        when Image
          asset.images << target_asset
        else
          raise UnhandledRelationType
        end


      when Transcript
        case target_asset
        when Video
          asset.video = target_asset
        when Audio
          asset.audio = target_asset
        when Program
          asset.program = target_asset
        else
          raise UnhandledRelationType
        end

      else
        raise UnhandledRelationType
      end

    end

    class UnhandledRelationType < StandardError; end

  end
end
