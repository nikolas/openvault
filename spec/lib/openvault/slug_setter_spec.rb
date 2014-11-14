require 'spec_helper'
require 'openvault/slug_setter'

describe Openvault::SlugSetter, not_on_travis: true do

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
      OVSS.solr_connection.delete_by_query("*:*", params: {commit: true}) 
      # TODO: Should not be necessary. https://github.com/projecthydra/active_fedora/issues/470
      
      v = Video.create
      old_id = v.id
      slug = 'New Slug!' # The API from here trusts your input: slugify is higher-level
      OVSS.reset_slug(old_id: old_id, slug: slug)
      
      # Now pull it back and make sure it's in both fedora and solr.
      expect(ActiveFedora::Base.find(old_id).datastreams['slug'].content).to eq slug
      expect(OVSS.solr_connection.find_by_id(slug)['pid']).to eq old_id
      
      ## Reset successfully
      
      old_slug = slug
      slug += '!!!'
      OVSS.reset_slug(old_slug: old_slug, slug: slug)
      
      expect(ActiveFedora::Base.find(old_id).datastreams['slug'].content).to eq slug
      expect(OVSS.solr_connection.find_by_id(slug)['pid']).to eq old_id
    end
  end
  
  pending '#set_missing_slugs' do
    it 'works' do
      OVSS.solr_connection.delete_by_query("*:*", params: {commit: true}) 
      # TODO: Should not be necessary. https://github.com/projecthydra/active_fedora/issues/470
      
      v = Video.create
      old_id = v.id
      # TODO: set title.
      OVSS.set_missing_slugs
      
      slug = '' # TODO: when title is set this will be filled.
      
      # Now pull it back and make sure it's in both fedora and solr.
      expect(ActiveFedora::Base.find(old_id).datastreams['slug'].content).to eq slug
      expect(OVSS.solr_connection.find_by_id(slug)['pid']).to eq old_id
    end
  end

end