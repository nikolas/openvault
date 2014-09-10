require 'spec_helper'
require 'openvault/slug_setter'

describe Openvault::SlugSetter do

  OVSS = Openvault::SlugSetter
  
  describe '#slugify' do
    it 'trims whitespace' do
      expect(OVSS.slugify '  no  padding  ').to eq 'no-padding'
    end
    it 'strips non-word' do
      expect(OVSS.slugify '123 !@# abc').to eq '123-abc'
    end
    it 'case normalizes' do
      expect(OVSS.slugify 'UpperCase').to eq 'uppercase'
    end
  end
  
  describe '#reset_slug' do
    it 'works' do
      v = Video.create
      v.save # Not in Video.all until saved... but not sure this behavior is right.
      old_id = v.id
      slug = 'New Slug!' # The API from here trusts your input: slugify is higher-level
      OVSS.reset_slug(old_id: old_id, slug: slug)
      
      # Now pull it back and make sure it's in both fedora and solr.
      new_v = ActiveFedora::Base.find(old_id)
      
      expect(new_v.datastreams['slug'].content).to eq slug
      expect(OVSS.solr_connection.find_by_id(slug)['pid']).to eq old_id
    end
  end

end