require 'rsolr'

namespace :openvault do
  desc "Set slugs on all unslugged records"
  task :set_slugs => :environment do |t, args|
    solr = solr_connection
    def slugify(string)
      string.downcase.gsub(/\W+/, ' ').strip.gsub(' ','-')
    end
    solr.no_pid.each do |doc|
      if doc['title_tesim']
        reset_slug(old_id: doc['id'], slug: slugify(doc['title_tesim'].first))
      else
        warn "No title on #{doc['id']}"
      end
    end
  end
  
  desc "Reset the slug on a single record"
  task :reset_slug => :environment do |t, args|
    OLD_ID_PARAM = 'old_id'
    OTHER_ID_PARAM = 'other_id'
    SLUG_PARAM = 'new_slug'
    
    if (!ENV[OLD_ID_PARAM] && !ENV[OTHER_ID_PARAM]) || !ENV[SLUG_PARAM]
      raise ArgumentError, "USAGE: rake openvault:reset_slug #{OLD_ID_PARAM}=[id]|#{OTHER_ID_PARAM}=[other_id] #{SLUG_PARAM}=[slug]"
    elsif ENV[OLD_ID_PARAM] && ENV[OTHER_ID_PARAM]
      raise ArgumentError, "Specify either #{OLD_ID_PARAM} or #{OTHER_ID_PARAM}, not both."
    end
    
    reset_slug old_id: ENV[OLD_ID_PARAM], other_id: ENV[OTHER_ID_PARAM], slug: ENV[SLUG_PARAM]    
  end
  
  desc "Reset slugs on multiple records"
  task :reset_slugs => :environment do |t, args|
    FILE_PARAM = 'file'
    if !ENV[FILE_PARAM]
      raise ArgumentError, "USAGE: rake openvault:reset_slugs #{FILE_PARAM}=[filename]"
    end
    File.open(ENV[FILE_PARAM], "r") do |f|
      f.each_line do |line|
        line.chomp!
        slug, other_id = line.split "\t" # This is arbitrary, but matches the order of the file we have.
        reset_slug other_id: other_id, slug: slug
      end
    end
  end
  
  private
  
  DSID = 'slug'
  PID = 'pid'
  
  def solr_connection
    solr = RSolr.connect url: 'http://localhost:8983/solr' # TODO: Should I get this from a configuration?
    def solr.no_pid()
      query = "-pid:*"
      count = self.get('select', params: {q: query, rows: 0})['response']['numFound']
      return self.get('select', params: {q: query, rows: count})['response']['docs']
    end
    def solr.query(field, id)
      return self.get('select', params: {q: "#{field}:#{id}"})['response']['docs']
    end
    def solr.id_exists?(old_id)
      return self.query('id',old_id).count > 0
    end
    def solr.find_by_id(old_id)
      docs = self.query('id',old_id)
      raise "Expected exactly one match on #{OLD_ID_PARAM}=#{old_id}, not #{docs.count}." if docs.count != 1
      docs.first
    end
    def solr.find_by_other_id(other_id)
      docs = self.query('all_ids_tesim',other_id)
      raise "Expected exactly one match on #{OTHER_ID_PARAM}=#{other_id}, not #{docs.count}." if docs.count != 1
      docs.first
    end
    solr
  end

  def reset_slug(opts)
    old_id = opts[:old_id]
    other_id = opts[:other_id]
    slug = opts[:slug]
    
    solr = solr_connection

    raise "Slug '#{slug}' is already in use: A solr record with that ID already exists." if solr.id_exists? slug

    # Find objects and make sure IDs are not already set.
    # TODO: allow overrides?

    if old_id
      doc = solr.find_by_id(old_id)
    elsif other_id
      doc = solr.find_by_other_id(other_id)
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

    puts "(Successfully changed '#{other_id || old_id}' to '#{slug}'.)"
  end

end
