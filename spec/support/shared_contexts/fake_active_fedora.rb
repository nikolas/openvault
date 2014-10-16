RSpec.shared_context 'fake_active_fedora' do
  let(:fake_active_fedora) { class_double(ActiveFedora::Base, find: fake_active_fedora_obj) }

  let(:fake_active_fedora_obj) { instance_double(ActiveFedora::Base, pid: 'abd:123') }
end