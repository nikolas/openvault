# TODO: Changes do not take effect without restarting Rails.

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
      [OaiModel.mock_object]
    else
      OaiModel.mock_object
    end
  end
  def self.mock_object
    Object.new.tap{|o|
      def o.id
        'id-TODO'
      end
      def o.timestamp_method
        # TODO
        Time.now
      end
    }
  end
  def timestamp_field
    'timestamp_method'
  end
end