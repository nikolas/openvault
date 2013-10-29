class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'pbcore', :type => PbcoreDescDoc
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)

    solr_document["slug"] = self.pid
    Solrizer.insert_field(solr_document, "title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "summary", self.summary, :displayable, :searchable)
    return solr_document
  end


  # #title should be overridden in subclasses in most cases.
  # For the base class, we just grab the first title found in the pbcore datastream.
  def title
    self.pbcore.all_titles.first
  end

  def summary
    self.pbcore.all_descriptions.first
  end


  def create_relations_from_pbcore!

  end

  def create_relations_from_pbcore_mars!
  end

  def create_relations_from_pbcore_artesia!

    # The pbcore datastream can give us Artesia UOI_IDs grouped by relation type,
    # but what we really want are PIDs, so let's look up the PID from the UOI_ID,
    # which is indexed as solr field "pbcoreDescriptionDocument_all_ids_tesim"
    pids_by_relation_type = {}
    pbcore.relations_by_type.each do |relation_type, uoi_ids|
      uoi_ids.each do |uoi_id|
        solr_response = Blacklight.solr.get('select', :params => {:q => "pbcoreDescriptionDocument_all_ids_tesim:#{uoi_id}"})
        if solr_response['response']['docs'].count > 0
          related_asset = self.class.find(solr_response['response']['docs'].first['id'], :cast => true)
          self.relate_asset related_asset
        end
      end
    end
  end

  # meant to be overridden
  def relate_asset asset
    raise "Do not know how to relate #{asset.class}."
  end

end
