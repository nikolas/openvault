require 'blacklight'

module Openvault
  module SolrHelper

    # extending ActiveSupport::Concerntrequired for correctly including module 
    # dependencies.
    extend ActiveSupport::Concern

    # Include module dependencies
    include Blacklight::Base
    include Blacklight::SolrHelper # source of get_solr_reponse_for_doc_id and get_solr_response_for_field_values


    def get_solr_response_for_doc_id_or_slug(id_or_slug)
      # first try looking up by slug
      response, documents = get_solr_response_for_field_values 'slug', id_or_slug
      document = documents.first

      # if searching by slug didn't work, try searching by id
      if document.nil?
        response, document = get_solr_response_for_doc_id id_or_slug
      end
      [response, document]
    end
  end
end