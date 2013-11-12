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

        # for each of the pbcore_ids...
        pbcore_ids.each do |pbcore_id|

          # ... find the first existing record that has that pbcore_id as a value for one of it's own <pbcoreIdentifier> nodes
          solr_response = Blacklight.solr.get('select', :params => {:q => "pbcoreDescriptionDocument_all_ids_tesim:#{pbcore_id}"})

          # If and when we find a match...
          if solr_response['response']['docs'].count > 0

            # Fetch the object from Fedora, and pass it to #relate_asset for this object.
            related_asset = self.class.find(solr_response['response']['docs'].first['id'], :cast => true)
            self.relate_asset related_asset
          end
        end
      end
    end
  end

  # meant to be overridden
  def relate_asset asset
    raise "Do not know how to relate #{asset.class}."
  end

end
