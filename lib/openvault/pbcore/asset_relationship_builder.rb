module Openvault::Pbcore
  class AssetRelationshipBuilder
    attr_accessor :asset

    def initialize(asset)
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


    def relate(relate_to)

      case asset

      when Series
        case relate_to
        when Program
          asset.programs << relate_to
        when Video
          asset.videos << relate_to
        when Audio
          asset.audios << relate_to
        when Image
          asset.images << relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end


      when Program
        case relate_to
        when Series
          asset.series = relate_to
        when Video
          asset.videos << relate_to
        when Audio
          asset.audios << relate_to
        when Image
          asset.images << relate_to
        when Transcript
          asset.transcripts << relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end

      when Video
        case relate_to
        when Series
          asset.series = relate_to
        when Program
          asset.program = relate_to
        when Image
          asset.images << relate_to
        when Transcript
          asset.transcripts << relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end

      when Image
        case relate_to
        when Video
          asset.video = relate_to
        when Program
          asset.program = relate_to
        when Series
          asset.series = relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end


      when Audio
        case relate_to
        when Series
          asset.series = relate_to
        when Program
          asset.program = relate_to
        when Transcript
          asset.transcripts << relate_to
        when Image
          asset.images << relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end


      when Transcript
        case relate_to
        when Video
          asset.video = relate_to
        when Audio
          asset.audio = relate_to
        when Program
          asset.program = relate_to
        else
          raise UnhandledRelationType.new(asset, relate_to)
        end

      else
        raise UnhandledRelationType.new(asset, relate_to)
      end

    end

    class UnhandledRelationType < StandardError
      def initialize(subject=nil, relate_to=nil)
        @subject = subject
        @relate_to = relate_to
      end

      def message
        "Do not know how to relate #{@relate_to.class} to #{@subject.class}"
      end
    end

  end
end
