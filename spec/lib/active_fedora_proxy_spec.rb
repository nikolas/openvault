require 'spec_helper'

require 'active_fedora_proxy'

require './spec/support/shared_contexts/fake_solr.rb'


describe ActiveFedoraProxy do

  include_context 'fake_solr'
  include_context 'fake_active_fedora'
  
  # Our target object is a test double object with a #solr_id method.
  let(:target_obj) { double solr_id: '111', fedora_pid: 'abc:123'}

  # Our subject, the ActiveFedoraProxy instance, given a test double as it's target object.
  let(:af_proxy) do
    af_proxy = ActiveFedoraProxy.new(target_obj)
    af_proxy.config.solr_service = fake_solr
    af_proxy.config.active_fedora = fake_active_fedora
    af_proxy
  end


  context 'providing access to a Solr document' do
    describe '#solr_id' do

      context 'by default' do
        it 'calls #solr_id on the target object' do
          # The :solr_id message is received twice, no matter how many times af_proxy.solr_id is called, which confuses Drew.
          # In this case, it is sufficient that `target_obj` receive :solr_id "at least once", but i would like to know why it is
          # received twice, even when I do `42.times { af_proxy.solr_id }`.
          # This only seems to happen within the test suite. Out in the wild, it appears to work as expected.
          expect(target_obj).to receive(:solr_id)
          af_proxy.solr_id
        end
      end

      context 'when config.get_solr_id_using has been changed' do

        context 'to a symbol other than :solr_id' do
          it 'calls the method specified by the symbol, instead of #solr_id' do
            allow(target_obj).to receive(:alt_method_for_getting_solr_id)
            af_proxy.config.get_solr_id_using = :alt_method_for_getting_solr_id
            expect(target_obj).to receive(:alt_method_for_getting_solr_id).once
            expect(target_obj).not_to receive(:solr_id)
            af_proxy.solr_id
          end
        end

        context 'to a callable thing (e.g. a Proc)' do
          it 'calls the callable thing instead of #solr_id, and passes to it the ActiveFedoraProxy instance' do
            af_proxy.config.get_solr_id_using = Proc.new do |afp|
              '222'
            end
            expect(target_obj).not_to receive(:solr_id)
            expect(af_proxy.solr_id).to eq '222'
          end
        end
      end

    end


    describe '#fetch_solr_doc!' do
      context 'when the solr document referred to by #solr_id exists' do
        it 'returns the solr document' do
          expect(af_proxy.fetch_solr_doc!).to be_a(Hash).and have_key('id')
        end
      end
      
      context 'when the solr document referred to by #solr_id does not exist' do
        it 'raises an error' do
          allow(fake_solr).to receive(:query).and_return(fake_solr_response_no_results)
          expect{ af_proxy.fetch_solr_doc! }.to raise_error ActiveFedoraProxy::SolrDocNotFound
        end
      end
    end

    describe '#fetch_solr_doc' do
      it 'calls #fetch_solr_doc!' do
        expect(af_proxy).to receive(:fetch_solr_doc!)
        af_proxy.fetch_solr_doc
      end

      context 'when solr document referred to by #solr_id does not exist' do
        it 'does not raise an error, but returns nil instead.' do
          allow(fake_solr).to receive(:query).and_return(fake_solr_response_no_results)
          expect{ af_proxy.fetch_solr_doc }.not_to raise_error
          expect(af_proxy.fetch_solr_doc).to be_nil
        end
      end
    end

    describe '#solr_doc' do
      context 'when the solr document referred to by #solr_id exists' do
        it 'calls fetch_solr_doc exactly once, even when #solr_doc is called more than once.' do
          # Stubbing :fetch_solr_doc here seems unnecessary, but apparently adding an `receive` expectation on :fetch_solr_doc causes it to automatically get stubbed anyway (maybe somewhere under the hood of rspec).
          # The problem is that the automatically stubbed :fetch_solr_doc returns nil, which would mean that no solr documents were found, and in that case, the caching idiom used in #solr_doc would fail to cache
          # and :fetch_solr_doc would get called again. So essentially, we have to stub it ourselves here, and have it return something that is not nil.
          allow(af_proxy).to receive(:fetch_solr_doc) { fake_solr_response }
          expect(af_proxy).to receive(:fetch_solr_doc).once
          2.times { af_proxy.solr_doc }
        end
      end

      context 'when the solr document referred to by #solr_id does not exist' do
        it 'call #fetch_solr_doc for as long as no document is found.' do
          allow(af_proxy).to receive(:fetch_solr_doc) { nil }
          expect(af_proxy).to receive(:fetch_solr_doc).exactly(2).times
          2.times { af_proxy.solr_doc }
        end
      end
    end
  end


  context 'providing access to a Fedora object' do
    describe '#fedora_pid' do

      context 'by default' do
        it 'will call #fedora_pid on the target object' do
          expect(target_obj).to receive(:fedora_pid).once
          af_proxy.fedora_pid
        end
      end

      context 'when config.get_fedora_pid_using has been changed' do

        context 'to a symbol other than :fedora_pid' do
          it 'calls the method specified by the symbol, instead of #solr_id' do
            allow(target_obj).to receive(:alt_method_for_getting_fedora_pid)
            af_proxy.config.get_fedora_pid_using = :alt_method_for_getting_fedora_pid
            expect(target_obj).to receive(:alt_method_for_getting_fedora_pid).once
            expect(target_obj).not_to receive(:fedora_pid)
            af_proxy.fedora_pid
          end
        end

        context 'to a callable thing (e.g. a Proc)' do
          it 'calls the callable thing instead of #solr_id, and passes to it the ActiveFedoraProxy instance' do
            af_proxy.config.get_fedora_pid_using = Proc.new do |afp|
              'fake-fedora-pid'
            end
            expect(target_obj).not_to receive(:fedora_pid)
            expect(af_proxy.fedora_pid).to eq 'fake-fedora-pid'
          end
        end
      end
    end

    describe '#fedora_object' do
      it 'calls fetch_fedora_object' do
        expect(af_proxy).to receive(:fetch_fedora_object)
        af_proxy.fedora_object
      end
    end

    describe '#fetch_fedora_object' do
      it 'calls fetch_fedora_object!' do
        expect(af_proxy).to receive(:fetch_fedora_object!)
        af_proxy.fetch_fedora_object
      end

      context 'when the fedora objct referred to by #fedora_pid does not exist' do
        it 'returns nil, and does not raise an error' do
          # spoof ActiveFedora's barfing up an error when it can't find the requested object.
          allow(fake_active_fedora).to receive(:find).and_raise(ActiveFedora::ObjectNotFoundError)
          expect{ af_proxy.fedora_object}.not_to raise_error
          expect(af_proxy.fedora_object).to be_nil
        end
      end
    end

    describe '#fetch_fedora_object!' do
      context 'when the fedora object referred to by #fedora_pid exists' do
        it 'returns the fedora object' do
          expect(af_proxy.fetch_fedora_object!).to be_a(ActiveFedora::Base).or be_a(fake_active_fedora_obj.class)
        end
      end

      context 'when ActiveFedora raises an ObjectNotFound error when attempting to find by #fedora_pid' do
        it 'raises the same ObjectNotFoundError' do
          # spoof ActiveFedora's barfing up an error when it can't find the requested object.
          allow(fake_active_fedora).to receive(:find).and_raise(ActiveFedora::ObjectNotFoundError)
          expect{ af_proxy.fetch_fedora_object! }.to raise_error ActiveFedora::ObjectNotFoundError
        end
      end
    end
  end
  

end