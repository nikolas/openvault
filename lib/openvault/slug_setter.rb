module Openvault
  module SlugSetter

    def self.reset_slug(opts)
      slug = opts.delete :slug
      raise "Only one id to lookup should be specified, not #{opts.keys}" if opts.keys.length>1
      
      id = opts.delete :id
      other_id = opts.delete :other_id
      old_slug = opts.delete :old_slug
      raise "Unrecognized options #{opts.keys}" if opts.keys.length>0 
      
      solr = solr_connection

      raise "Slug '#{slug}' is already in use: " if solr.query('slug', slug).count > 0

      # Find objects and make sure IDs are not already set.
      # TODO: allow overrides?

      if old_slug
        doc = solr.query_one('slug', old_slug)
      elsif id
        doc = solr.find_by_id(id)
      elsif other_id
        doc = solr.find_by_other_id(other_id)
      end

      # Set slug on objects.
      doc['slug'] = slug
      doc.delete 'score'
      solr.add doc
      solr.commit

      puts "(Successfully changed slug for solr doc '#{other_id || doc['id']}' from '#{old_slug}' to '#{slug}'.)"
    end
    
    def self.set_missing_slugs
      solr = solr_connection
      solr.no_slug.each do |doc|
        id = doc['id']
        ng_xml = ActiveFedora::Base.find(id, cast: true).pbcore.ng_xml
        title_blob = ng_xml.xpath('//pbcoreTitle/text()').map{|x| x.to_s}.join('|')
        id_blob = ng_xml.xpath('//pbcoreIdentifier/text()').map{|x| x.to_s}.join('|')
        slug = slugify(title_blob + '-' + Digest::MD5.hexdigest(id_blob)[0..9])
        reset_slug(id: id, slug: slug)
      end
    end
    
    def self.slugify(string)
      string.downcase.gsub(/\W+/, ' ').strip.gsub(' ','-')
    end
    
    ###
    # Would be private, if not used for testing.
    ###


    def self.solr_connection
      @solr_connection ||= self.init_solr_connection
    end

    private

    def self.init_solr_connection
      solr = ActiveFedora::SolrService.instance.conn
      
      def solr.no_slug()
        query = "-slug:*"
        count = self.get('select', params: {q: query, rows: 0})['response']['numFound']
        get('select', params: {q: query, rows: count})['response']['docs']
      end
      
      def solr.query(field, val)
        get('select', params: {q: "#{field}:#{RSolr.escape(val)}"})['response']['docs']
      end
      
      def solr.query_one(field, val)
        docs = query(field, val)
        raise "Expected exactly one match on #{field} '#{val}', not #{docs.count}." if docs.count != 1
        docs.first
      end
      
      def solr.id_exists?(id)
        return query('id',id).count > 0
      end
      
      def solr.find_by_id(id)
        query_one('id', id)
      end
      
      def solr.find_by_other_id(id)
        query_one('all_ids_tesim', id)
      end
      
      solr
    end

  end
end