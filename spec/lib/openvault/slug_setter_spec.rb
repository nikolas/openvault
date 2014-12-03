require 'spec_helper'
require 'openvault/slug_setter'

require "#{RSpec.configuration.fixture_path}/pbcore/load_fixtures"

describe Openvault::SlugSetter, not_on_travis: true do
  
  before(:each) { Fixtures.cwd("#{fixture_path}/pbcore") }

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
      slug = 'New Slug!' # The API from here trusts your input: slugify is higher-level
      OVSS.reset_slug(id: v.id, slug: slug)
      
      # Now pull it back and make sure it's in both fedora and solr.
      expect(OVSS.solr_connection.find_by_id(v.id)['slug']).to eq slug
      
      ## Reset successfully
      
      old_slug = slug
      slug += '!!!'
      OVSS.reset_slug(old_slug: old_slug, slug: slug)
      
      expect(OVSS.solr_connection.find_by_id(v.id)['slug']).to eq slug
    end
  end
  
  describe '#set_missing_slugs' do
    it 'works' do
      OVSS.solr_connection.delete_by_query("*:*", params: {commit: true}) 
      # TODO: Should not be necessary. https://github.com/projecthydra/active_fedora/issues/470
      
      v = Video.create
      v.pbcore.ng_xml = Fixtures.use('artesia/rock_and_roll/video_1.xml').ng_xml
      v.save!
      # TODO: set title.
      OVSS.set_missing_slugs
      
      slug = 'rock-and-roll-respect-104-interview-with-rufus-thomas-part-2-of-4-0d7aa98cee'
      
      # Now pull it back and make sure it's in both fedora and solr.
      expect(OVSS.solr_connection.find_by_id(v.id)['slug']).to eq slug
    end
  end

end