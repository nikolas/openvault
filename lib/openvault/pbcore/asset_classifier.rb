module Openvault::Pbcore
  module AssetClassifier
        
    def self.classify(doc)
      matches = []
      MODELS.each do |model, test|
        matches << Kernel.const_get(model) if test.call(doc)
      end
      matches -= [Program] unless matches == [Program]
      raise NoMatchingActiveFedoraModel, 
        "No matching AF-model for pbcore with ids=#{doc.all_ids.inspect}\n#{self.info(doc)}" if matches.count == 0
      raise MultipleMatchingActiveFedoraModels, 
        "Multiple matching AF-models: #{matches} for pbcore with ids=#{doc.all_ids.inspect}\n#{self.info(doc)}" if matches.count > 1
      return matches.first
    end
    
    private
    
    def self.info(doc)
      <<EOF 
asset_type: #{self.asset_type(doc)}
media_type: #{self.media_type(doc)}
digital: #{self.digital(doc)} 
titles_by_type: #{doc.titles_by_type.keys}
EOF
    end
    
    
    MODELS = {
      # Bare classes could be used at runtime, but they choked 'rake dev:ci:prepare'
      'Series' => lambda {|doc| 
        ([['Series'],['Collection','Series']].include? doc.titles_by_type.keys.sort) &&
          doc.instantiation.media_type.empty? &&
          doc.instantiation.digital.empty?},
      
      'Program' => lambda {|doc|
        !doc.program_title.empty? &&
          doc.titles_by_type.keys.grep(/^(Element|Item|Segment|Clip)/).none?},
      
      'Transcript' => lambda {|doc|
        asset_type(doc).match(/transcript/i) ||
          asset_type(doc).match(/documentation/i) ||
          asset_type(doc).match(/logs/i)},
      
      'Video' => lambda {|doc|
        media_type(doc).match(/^moving image$/i) || 
          asset_type(doc).match(/^preservation master$/i) ||
          digital(doc).match(/^video/) ||
          doc.titles_by_type.keys.include?('Clip')},
      
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
      doc.instantiation(0).media_type.first || ''
    end
    
    def self.digital(doc)
      doc.instantiation.digital.first || ''
    end


    class MultipleMatchingActiveFedoraModels < StandardError; end
    class NoMatchingActiveFedoraModel < StandardError; end

  end
end
