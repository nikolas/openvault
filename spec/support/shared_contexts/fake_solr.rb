RSpec.shared_context 'fake_solr' do

  # Fake Solr service, with a stubbed method for :query that returns our fake_solr_response.
  # To have :fake_solr return fake_solr_response_no_results, you can re-stub the :query method like so...
  #  allow(fake_solr).to receive(:query).and_return(fake_solr_response_no_results)
  let(:fake_solr) { class_double(ActiveFedora::SolrService, query: fake_solr_response) }
  
  let(:fake_solr_response) do
    {
      'response' => {
        'docs' => [
          {'id' => target_obj.solr_id}
        ]
      }
    }
  end

  let(:fake_solr_response_no_results) { {'response' => {'numFound' => 0, 'docs' => []}} }
  
end