module Openvault::Pbcore
  module AssetClassifier
        
    def self.classify(doc)
      matches = []
      MODELS.each do |model, test|
        matches << Kernel.const_get(model) if test.call(doc)
      end
      matches -= [Program] unless matches == [Program]
      raise 'No matching AF-model' if matches.count == 0
      raise "Multiple matching AF-models: #{matches}" if matches.count > 1
      return matches.first
    end 
    
    private
    
    MODELS = {
      # Bare classes could be used at runtime, but they choked 'rake dev:ci:prepare'
      'Series' => lambda {|doc| 
        !doc.series_title.empty? && 
          doc.program_title.empty? && 
          doc.instantiations.media_type.empty?},
      
      'Program' => lambda {|doc|
        !doc.program_title.empty? &&
          doc.titles_by_type.keys.grep(/^(Element|Item|Segment|Clip)/).none?},
      
      'Transcript' => lambda {|doc|
        asset_type(doc).match(/transcript/i) ||
          asset_type(doc).match(/logs/i)},
      
      'Video' => lambda {|doc|
        media_type(doc).match(/^moving image$/i) || 
          asset_type(doc).match(/^preservation master$/i)},
      
      'Audio' => lambda {|doc|
        media_type(doc).match(/^audio$/i)},
      
      'Image' => lambda {|doc|
        media_type(doc).match(/^static image$/i) ||
          asset_type(doc).match(/photograph/i) || 
          digital(doc).match(/^image/)
      }
    }
    
    def self.asset_type(doc)
      doc.asset_type.first || ''
    end
    
    def self.media_type(doc)
      doc.instantiations(0).media_type.first || ''
    end
    
    def self.digital(doc)
      doc.instantiations.digital.first || ''
    end

  end
end
