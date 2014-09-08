require 'rsolr'

solr = RSolr.connect url: 'http://localhost:8983/solr' # TODO: Should I get this from a configuration?
def solr.find_by_id(old_id)
  docs = self.get('select', params: {q: "id:#{old_id}"})['response']['docs']
  raise "Expected exactly one match on #{OLD_ID_PARAM}=#{old_id}, not #{docs.count}." if docs.count != 1
  docs.first
end
def solr.find_by_art_id(art_id)
  docs = self.get('select', params: {q: "all_ids_tesim:#{art_id}"})['response']['docs']
  raise "Expected exactly one match on #{ART_ID_PARAM}=#{art_id}, not #{docs.count}." if docs.count != 1
  docs.first
end

namespace :openvault do
  desc "Reset the slug on a single record"
  task :reset_slug => :environment do |t, args|
    OLD_ID_PARAM = 'old_id'
    ART_ID_PARAM = 'art_id'
    SLUG_PARAM = 'new_slug'
    
    if (!ENV[OLD_ID_PARAM] && !ENV[ART_ID_PARAM]) || !ENV[SLUG_PARAM]
      raise ArgumentError, "USAGE: rake openvault:reset_slug #{OLD_ID_PARAM}=[id]|#{ART_ID_PARAM}=[art_id] #{SLUG_PARAM}=[slug]"
    elsif ENV[OLD_ID_PARAM] && ENV[ART_ID_PARAM]
      raise ArgumentError, "Specify either #{OLD_ID_PARAM} or #{ART_ID_PARAM}, not both."
    end
    
    old_id = ENV[OLD_ID_PARAM] rescue nil
    art_id = ENV[ART_ID_PARAM] rescue nil
    slug = ENV[SLUG_PARAM]
    
    begin
      solr.find_by_id(slug)
      raise "Slug '#{slug}' is already in use: A solr record with that ID already exists."
    rescue
      # Expect slug not to exist and lookup to fail
    end
    
    # Find objects and make sure IDs are not already set.
    # TODO: allow overrides?
    
    DSID = 'slug'
    PID = 'pid'
    
    if old_id
      doc = solr.find_by_id(old_id)
    elsif art_id
      doc = solr.find_by_art_id(art_id)
      old_id = doc['id']
    end
    raise "Solr doc with id '#{old_id}' already has a PID (#{doc[PID]})." if doc[PID]
    
    asset = ActiveFedora::Base.find(old_id, cast: true)
    raise "Fedora object with PID #{old_id} already has datastream #{DSID}" if asset.datastreams.keys.include? DSID
    
    # Set new IDs on objects.
    
    doc[PID] = old_id
    doc['id'] = slug
    doc.delete 'score'
    
    solr.delete_by_id(old_id)
    solr.add doc
    solr.commit
    
    # This datastream isn't used right now, but I think the cross reference is good.
    ds = asset.create_datastream(ActiveFedora::Datastream, DSID, blob: slug, mimeType: 'text/plain')
    ds.save
    
    puts "(Successfully changed '#{art_id || old_id}' to '#{slug}'.)"
  end
end
