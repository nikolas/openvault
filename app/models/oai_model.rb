# TODO: Changes do not take effect without restarting Rails.

class OaiDocument
  attr_reader :id, :timestamp, :xml
  def initialize(solr_hash)
    @id = solr_hash['id']
    @timestamp = Time.new(solr_hash['timestamp'])
    @xml = ActiveFedora::Base.find(solr_hash['id'], cast: true).datastreams['pbcore'].to_xml
  end
end

class OaiModel
  
  # Tried including Openvault::SolrHelper
  # but it has its own find method, and ours collides with it.
  
  def self.fq
    ['Video', 'Audio', 'Image'].map{|type| 'has_model_ssim:"info:fedora/afmodel:'+type+'"'}.join(' OR ')
  end
  
  def self.earliest_or_latest(order)
    r = Blacklight.solr.select(params: {
        q: '*:*', sort: "timestamp #{order}", rows: '1', fl: 'timestamp', fq: OaiModel.fq
    })
    r['response']['docs'][0]['timestamp']
  end
  
  def earliest
    OaiModel.earliest_or_latest('asc')
  end
  def latest
    OaiModel.earliest_or_latest('desc')
  end
  def sets
    # TODO: perhaps different sets for different asset types?
    []
  end
  def find(id, options)
    if id == :all
      response = Blacklight.solr.select(params: { q: '*:*', fq: OaiModel.fq })['response']
      response['docs'].map { |doc| OaiDocument.new(doc) }
    else
      return OaiModel.mock_object
      # TODO:
      response = Blacklight.solr.select(params: {q: "id:#{id}", fq: OaiModel.fq})['response']
    end
  end
  def self.mock_object
    Object.new.tap{|o|
      def o.id
        'id-TODO'
      end
      def o.timestamp
        # TODO
        Time.now
      end
      def o.xml
        '<TODO/>'
      end
    }
  end
  def timestamp_field
    'timestamp'
  end
end