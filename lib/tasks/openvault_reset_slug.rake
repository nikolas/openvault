require 'rsolr'

namespace :openvault do
  desc "Reset the slug on a single record"
  task :reset_slug => :environment do |t, args|
    
    id_param = 'old_id'
    slug_param = 'new_slug'
    
    if !ENV[id_param] || !ENV[slug_param]
      raise ArgumentError, "USAGE: rake openvault:reset_slug #{id_param}=[id] #{slug_param}=[slug]"
    end
    
    old_id = ENV[id_param]
    slug = ENV[slug_param]

    solr = RSolr.connect url: 'http://localhost:8983/solr' # TODO: Should I get this from a configuration?
    def solr.find_by_id(solr_id)
      self.get('select', params: {q: "id:#{solr_id}"})['response']['docs'].first
    end
    
    raise "Slug '#{slug}' is already in use: A solr record with that ID already exists." if solr.find_by_id(slug)
    
    
    # Find objects and make sure IDs are not already set.
    # TODO: allow overrides?
    
    DSID = 'slug'
    PID = 'pid'
    
    asset = ActiveFedora::Base.find(old_id, cast: true)
    raise "Fedora object with PID #{old_id} already has datastream #{DSID}" if asset.datastreams.keys.include? DSID
    
    doc = solr.find_by_id(old_id)
    raise "No Solr doc with id '#{old_id}'." unless doc
    raise "Solr doc with id '#{old_id}' already has a PID (#{doc[PID]})." if doc[PID]
    
    
    # Set new IDs on objects.
    
    ds = asset.create_datastream(ActiveFedora::Datastream, DSID, blob: slug, mimeType: 'text/plain')
    ds.save
    
    doc[PID] = old_id
    doc['id'] = slug
    doc.delete 'score'
    
    solr.delete_by_id(old_id)
    solr.add doc
    solr.commit
    
    puts "(Successfully changed '#{old_id}' to '#{slug}'.)"
  end
end
