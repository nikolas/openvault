module Openvault
  module SlugSetter

    def self.reset_slug(opts)
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
    
    def self.set_missing_slugs
      solr = solr_connection
      solr.no_pid.each do |doc|
        if doc['title_tesim']
          # TODO: should it be a combo of series and program title?
          # TODO: should it have a fallback if the name is already in use?
          reset_slug(old_id: doc['id'], slug: slugify(doc['title_tesim'].first))
        else
          warn "No title on #{doc['id']}"
        end
      end
    end
    
    def self.slugify(string)
      string.downcase.gsub(/\W+/, ' ').strip.gsub(' ','-')
    end
    
    private

    DSID = 'slug'
    PID = 'pid'  

    def self.solr_connection
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

  end
end