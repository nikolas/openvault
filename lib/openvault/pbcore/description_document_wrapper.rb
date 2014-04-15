module Openvault::Pbcore
  class DescriptionDocumentWrapper
 
    def initialize(doc=nil)
      @doc = doc unless doc.nil?
      @classifier = AssetClassifier.new(@doc)      
    end

    def doc
      raise 'No PbcoreDescDoc specified. Set with #doc=' unless @doc
      @doc
    end

    def doc=(doc)
      raise ArgumentError, 'Object must be a PbcoreDescDoc' unless doc.is_a? PbcoreDescDoc
      @doc = doc
      @classifier.doc = doc
    end
    
    # Returns appropriate ActiveFedora model class for the pbcore datastream
    def model_class
      %w(series program transcript video audio image).each do |type| 
        return Kernel.const_get(type.classify) if (@classifier.send("is_#{type}?".to_s))
      end
      raise "Hey, I don't know which model to use for this pbcore: #{self.doc.inspect}" 
    end 

    def new_model 
      model_class.new.tap do |model|
        model.pbcore.ng_xml = doc.ng_xml
      end
    end

    # Uses values from <pbcoreIdentifier> nodes to check
    # Fedora for existing instances of models that contain
    # those values. If not found, returns a new model, and assigns
    # the pbcore datastream to it.
    def model 
      @model ||= fedora_models.first || new_model
    end

    def fedora_models
      @fedora_models ||= ActiveFedora::Base.find({"all_ids_tesim" => doc.all_ids})
    end

    def non_program_titles
      # get all of the title types that would indicate a record *other* than a Program record
      @non_program_titles ||= doc.titles_by_type.keys.select do |title_type|
        !!(title_type =~ /^Element/) || !!(title_type =~ /^Item/) || !!(title_type =~ /^Segment/) || !!(title_type =~ /^Clip/)  
      end
    end

  end
end
