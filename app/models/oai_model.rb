class OaiModel
  
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
      response = Blacklight.solr.select(params: {q: "slug:#{id}", fq: OaiModel.fq})['response']
      response = Blacklight.solr.select(params: {q: "id:#{id}", fq: OaiModel.fq})['response'] if response['docs'].empty?
      OaiDocument.new(response['docs'][0])
    end
  end
  def timestamp_field
    'timestamp'
  end
  
  private
  
  def self.fq
    ['Video', 'Audio', 'Image'].map{|type| 'has_model_ssim:"info:fedora/afmodel:'+type+'"'}.join(' OR ')
  end
  def self.earliest_or_latest(order)
    r = Blacklight.solr.select(params: {
        q: '*:*', sort: "timestamp #{order}", rows: '1', fl: 'timestamp', fq: OaiModel.fq
    })
    r['response']['docs'][0]['timestamp']
  end
  
end