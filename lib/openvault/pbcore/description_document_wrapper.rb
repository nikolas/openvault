module Openvault::Pbcore
  class DescriptionDocumentWrapper

    def initialize(doc=nil)
      @doc = doc unless doc.nil?
    end

    def doc
      raise 'No PbcoreDescDoc specified. Set with #doc=' unless @doc
      @doc
    end

# TODO: delete if really unused.    
#    def doc=(doc)
#      raise ArgumentError, 'Object must be a PbcoreDescDoc' unless doc.is_a? PbcoreDescDoc
#      @doc = doc
#      @classifier.doc = doc
#    end

# TODO: Could we just call it directly?
     def model_class
       AssetClassifier.classify(@doc)
     end
# TODO: delete
#    # Returns appropriate ActiveFedora model class for the pbcore datastream
#    def model_class
#      if @classifier.one_model?
#        AssetClassifier.asset_types.each do |type|
#          return Kernel.const_get(type.classify) if (@classifier.send("is_#{type}?".to_s))
#        end
#        raise "Hey, I don't know which model to use for this pbcore: #{self.doc.all_ids}"
#      end
#    end

    def new_model
      model_class.new.tap do |model|
        model.pbcore.ng_xml = doc.ng_xml
      end
    end

    # Uses values from <pbcoreIdentifier> nodes to check
    # Fedora for existing instances of models that contain
    # those values. If not found, returns a new model, and assigns
    # the pbcore datastream to it.
    def model(opts={})
      if opts[:reset_from_pbcore]
        # TODO: delete if really unused.
        @model = fedora_models(refresh: true).first || new_model
      else
        @model ||= fedora_models.first || new_model
      end
    end

    def fedora_models(opts={})
      if opts[:refresh]
        # TODO: delete if really unused.
        @fedora_models = ActiveFedora::Base.find({"all_ids_tesim" => doc.all_ids})
      else
        @fedora_models ||= ActiveFedora::Base.find({"all_ids_tesim" => doc.all_ids})
      end
    end
  end
end
