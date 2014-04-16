module SearchHelper

  # XXX 
  def top_level_categories
    response = Blacklight.solr.select :params => { :rows => 0, :'facet.field' => 'category_sim'}
    items = []
    response['facet_counts']['facet_fields']['category_sim'].each_slice(2) do |k,v|
      items << [:value => k, :hits => v]
    end
    items
  end
  
  def top_level_collections
    collections = Collection.find(:all,:select => 'name, slug')
    arr = []
    collections.each do |coll|
      arr << [coll.name, coll.slug]
    end
    arr
  end

  def collections_list
    response = Blacklight.solr.select :params => { :rows => 100, :fq => ['active_fedora_model_ssi:(Series)'], 'fl' => 'id,title_tesim,active_fedora_model_ssi,slug,summary_ssm' }
    items = []
    response['response']['docs'].each do |s|
      items << s['title_tesim']
    end
    items
  end
end
