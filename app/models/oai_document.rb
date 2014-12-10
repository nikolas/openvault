class OaiDocument
  attr_reader :id, :timestamp, :xml
  def initialize(solr_hash)
    @id = "http://openvault.wgbh.org/catalog/#{solr_hash['slug'] || solr_hash['id']}"
    @timestamp = Time.new(solr_hash['timestamp'])
    @xml = ActiveFedora::Base.find(solr_hash['id'], cast: true).datastreams['pbcore'].to_xml
  end
end