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
    response = Blacklight.solr.select :params => { :rows => 100, :fq => ['dc_type_s:(Series OR Collection)'], 'fl' => 'id,title_display,dc_type_s,pid_s,dc_description_t', 'sort' => 'title_sort asc' }
    #response.docs.map { |x| SolrDocument.new(x) }
  end
end
