require 'openvault'

module Openvault::Pbcore
<<<<<<< HEAD
  class DescriptionDocumentWrapper
 
    def initialize(doc=nil)
      self.doc = doc unless doc.nil?
    end

    def doc
      raise 'No PbcoreDescDoc specified. Set with #doc=' unless @doc
      @doc
    end

    def doc=(doc)
      raise ArgumentError, 'Object must be a PbcoreDescDoc' unless doc.is_a? PbcoreDescDoc
=======
  class DescriptionDocumentWrapper 

    attr_accessor :doc
 
    def initialize(doc=nil)
>>>>>>> Initial reorg
      @doc = doc
      @classifier = AssetClassifier.new(@doc)      
    end

    def doc=(doc)
      @classifier.doc = @doc
    end
    
    # Returns appropriate ActiveFedora model class for the pbcore datastream
    def model_class
      %w(series program transcript video audio image).each do |type| 
        return Kernel.const_get(type.classify) if (send("is_#{type}?".to_s))
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

  class Ingester
    attr_accessor :xml, :pids 

    def initialize(xml)
      @xml = xml
      @pids = []
    end

    def find_by_pbcore_ids pbcore_ids
      pbcore_ids = Array.wrap(pbcore_ids)
      ActiveFedora::Base.find("all_ids_tesim" => pbcore_ids)
    end

    def ng_xml
      @namespaced_xml ||= Openvault::XML(xml)
      @ng_xml ||= @namespaced_xml.remove_namespaces!
    end

    def ng_pbcore_desc_docs 
      @ng_pbcore_desc_docs ||= ng_xml.xpath('//pbcoreDescriptionDocument')
    end

    def with_desc_docs &block
      ng_pbcore_desc_docs.each do |ng_pbcore_desc_doc|
        wrapper = DescriptionDocumentWrapper.new
        wrapper.doc = PbcoreDescDoc.new.tap do |doc|
                        doc.ng_xml = ng_pbcore_desc_doc
                      end
        
        yield wrapper
      end
    end

    def ingest!
      with_desc_docs do |doc|
        doc.model.save! 
        self.pids << doc.model.pid
      end

      relate_pids!
    end

    def ingest 
      with_desc_docs do |doc|
        begin
          doc.model.save && (self.pids << doc.model.pid)
        rescue Exception => e
          Rails.logger.error(e.message)
        end
      end

      relate_pids
    end

    def relate_pids!
      pids.each do |pid|
        OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
      end
    end

    def relate_pids
      pids.each do |pid|
        begin
          OpenvaultAsset.find(pid, cast: true).try(:create_relations_from_pbcore!)
        rescue Exception => e
          Rails.logger.error("** Error: #{e.message}")
        end
      end
    end
  end
end
