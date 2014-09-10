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
      OVSS.reset_slug(old_id: v.id, slug: 'NEW SLUG!')
      
      # Now pull it back and make sure it's in both fedora and solr.
#      new_v = Video.all.first
#      expect(new_v.slug.content).to eq 'new-slug'
#      expect(OVSS.solr_connection.find_by_id('new-slug')).to eq 'huh?'
    end
  end

end