require 'spec_helper'
require 'openvault/solr_helper'

class FakeController < ApplicationController
  include Openvault::SolrHelper
end


describe 'Openvault::SolrHelper (mixed into a dummy controller)', type: :controller do

  subject do
    fake_controller = FakeController.new
    allow(fake_controller).to(
      receive(:request).and_return(
        double(parameters: {})
      )
    )
    fake_controller
  end

  before do
    @sample_hash = {'id' => '123', 'slug' => 'sample-slug'}
    Blacklight.solr.add @sample_hash
    Blacklight.solr.commit
  end


  describe '#get_solr_response_for_doc_id_or_slug' do

    let!(:retrieved_with_id) { subject.get_solr_response_for_doc_id_or_slug(@sample_hash['id']) }
    let!(:retrieved_with_slug) { subject.get_solr_response_for_doc_id_or_slug(@sample_hash['slug']) }

    it 'returns a pair of objects, SolrResponse and SolrDocument' do
      response, document = *retrieved_with_id
      expect(response).to be_a Blacklight::SolrResponse
      expect(document).to be_a SolrDocument
    end

    it 'returns the correct SolrDocument when retrieved by id or slug' do
      document_retreived_with_id = retrieved_with_id[1]
      document_retreived_with_slug = retrieved_with_slug[1]
      expect(document_retreived_with_id['id']).to eq @sample_hash['id']
      expect(document_retreived_with_id['slug']).to eq @sample_hash['slug']
      expect(document_retreived_with_slug['id']).to eq @sample_hash['id']
      expect(document_retreived_with_slug['slug']).to eq @sample_hash['slug']
    end
  end
end
