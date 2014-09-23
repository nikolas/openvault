module LookupBySlug
  def lookup id
    response, document = get_solr_response_for_doc_id id rescue nil
    pid = document[:pid] || id rescue id
    ov_asset = ActiveFedora::Base.find(pid, cast: true) rescue nil
    {
      response: response,
      document: document,
      ov_asset: ov_asset
    }
  end
end
