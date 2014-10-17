# require_relative 'fake_solr.rb'
# require_relative 'fake_active_fedora.rb'

RSpec.shared_context 'fake_active_fedora_proxy' do

  include_context 'fake_solr'
  include_context 'fake_active_fedora'

  let(:fake_active_fedora_proxy) do
    fake_af_proxy = instance_double(ActiveFedoraProxy)
    fake_af_proxy.config.solr_service = fake_solr
    fake_af_proxy.config.active_fedora = fake_active_fedora
  end
end