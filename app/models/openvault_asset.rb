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
    Solrizer.insert_field(solr_document, "date_portrayed", self.date_portrayed, :stored_searchable, :dateable)
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

  def date_portrayed
    self.pbcore.coverage.date_portrayed.first
  end

  # meant to be overridden
  def relate_asset asset
    raise "Do not know how to relate #{self.class} to #{asset.class}."
  end

  def media_host
    "http://mlamedia01.wgbh.org/openvault"
  end
  
  def rights_rights
    rights(:rights)
  end
  def rights_coverage
    rights(:coverage)
  end
  def rights_credit
    rights(:credit)
  end
  def rights_holder
    rights(:holder)
  end
  def rights_note
    rights(:note)
  end
  def rights_type
    rights(:type)
  end
  def rights_link
    # If licensing requires us to link back
    case rights_holder
    when 'CBS News' 
      'Footage courtesy of <a href="http://www.cbsnews.com/">CBS News</a>'.html_safe
    when 'ABC News VideoSource'
      'Footage courtesy of <a href="http://abcnews.go.com/">ABC News</a>'.html_safe
    else
      nil
    end
  end
  
  private
  
  def rights(detail)
    self.pbcore.rights.send(detail).first
  end
  
end
