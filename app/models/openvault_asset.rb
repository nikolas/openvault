class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'pbcore', :type => PbcoreDescDoc

  def accept_annotations
    #logic will go here to accept annotations from scholars
  end

  def solr_doc
    item = Blacklight.solr.select(params: {q: "id:#{id}"})
    raise 'CustomCollectionItem could not find corresponding solr document' unless item['response']['docs'].first
    item['response']['docs'].first
  end

  def kind
    self.class.to_s.downcase
  end

  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    Solrizer.insert_field(solr_document, "title", self.title, :stored_searchable, :sortable)
    Solrizer.insert_field(solr_document, "summary", self.summary, :stored_searchable)
    Solrizer.insert_field(solr_document, "asset_date", self.asset_date, :stored_searchable, :dateable)
    Solrizer.insert_field(solr_document, "thumbnail", self.thumbnail_url, :displayable)
    return solr_document
  end

  # #title should be overridden in subclasses in most cases.
  # For the base class, we just grab the first title found in the pbcore datastream.
  def title
    self.pbcore.all_titles.first
  end

  def summary
    # '.last' in this case because the summary supplied by the scholar follows the original description.
    self.pbcore.all_descriptions.last
  end

  def thumbnail_url
    # no-op. Override in extended classes
    "no_image.gif"
  end

  def asset_date
    self.pbcore.asset_date.first
  end

  # meant to be overridden
  def relate_asset asset
    raise "Do not know how to relate #{asset.class}."
  end

  def media_host
    "http://mlamedia01.wgbh.org/openvault"
  end
end
