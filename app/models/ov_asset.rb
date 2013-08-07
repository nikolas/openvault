# Generated via
#  `rails generate active_fedora::model OvAsset`
class OvAsset < ActiveFedora::Base
  
  # Creating a #descMetadata method that returns the datastream. 
  #
  has_metadata "descMetadata", type: OvAssetMetadata
  
  # Uncomment the following lines to add an #attachment method that is a
  #   file_datastream:
  #
  # has_file_datastream "attachment"
  
  # "If you need to add additional attributes to the SOLR document, define the
  # #to_solr method and make sure to use super"
  #
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["the_title"] = my_attribute
    return solr_document
  end

end
