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
    Solrizer.insert_field(solr_document, "thumbnail", self.thumbnail_url)
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

  def thumbnail_url
    # no-op. Override in extended classes
  end

  def create_relations_from_pbcore_mars!
    raise 'this needs to be coded!'
  end

  # Uses pbcore.relations_by_type to establish ActiveFedora relations with existing fedora objects.
  # NOTE: This method assumes:
  #   * Two records are related when a value within one record's <pbcoreIdentifier> node is present in another's <pbcoreRelationIdentifier> node
  #   * There is only one <pbcoreRelationIdentifier> per <pbcoreRelation>
  def create_relations_from_pbcore!



    if !pbcore.relations_by_type.empty?
      # For each relation type, there is a list of values from <pbcoreRelationIdentifier> nodes, that we will call pbcore_ids
      pbcore.relations_by_type.each do |relation_type, pbcore_ids|

        # for each of the pbcore_ids specified in the <pbcoreRelationIdentifier> nodes
        pbcore_ids.each do |pbcore_id|

          # find the records that have that pbcore_id as it's <pbcoreIdentifier>, which is stored in all_ids_tesim
          related_assets = ActiveFedora::Base.find({:all_ids_tesim => pbcore_id})

          related_assets.each do |related_asset|
            self.relate_asset related_asset
            self.save!
          end
        end
      end
    end
  end

  # meant to be overridden
  def relate_asset asset
    raise "Do not know how to relate #{asset.class}."
  end

  def media_host
    "http://mlamedia01.wgbh.org/openvault"
  end

end
