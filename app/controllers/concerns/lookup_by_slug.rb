require 'blacklight'

module LookupBySlug

  # required for correctly including module dependencies here, as opposed to the class/module including this module.
  extend ActiveSupport::Concern

  include Blacklight::Base

  # This is where get_solr_reponse_for_doc_id is defined
  include Blacklight::SolrHelper

  def lookup id
    response, document = get_solr_response_for_doc_id id
    pid = document[:pid] || document['pid'] || id rescue id
    ov_asset = ActiveFedora::Base.find(pid, cast: true) rescue nil 
    {   
      response: response,
      document: document,
      ov_asset: ov_asset
    }   
  end 
end