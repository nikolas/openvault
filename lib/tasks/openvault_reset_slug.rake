require 'rsolr'

namespace :openvault do
  desc "Reset the slug on a single record"
  task :reset_slug => :environment do |t, args|
    
    id_param = 'solr_id'
    slug_param = 'new_slug'
    
    if !ENV[id_param] || !ENV[slug_param]
      raise ArgumentError, "USAGE: rake openvault:reset_slug #{id_param}=[id] #{slug_param}=[slug]"
    end
    
    solr_id = ENV[id_param]
    slug = ENV[slug_param]

    solr = RSolr.connect url: 'http://localhost:8983/solr' # TODO: Should I get this from a configuration?
    def solr.find_by_id(solr_id)
      self.get('select', params: {q: "id:#{solr_id}"})['response']['docs'].first
    end
    
    doc = solr.find_by_id(solr_id)
    doc['pid'] = solr_id
    doc['id'] = slug
    doc.delete 'score'
    
    solr.delete_by_id solr_id
    solr.add doc
    solr.commit
  end
end
