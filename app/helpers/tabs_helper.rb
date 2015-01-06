module TabsHelper
  
  def tabs_for(id_or_slug, tab_names)
    media = lookup_media(id_or_slug)
    tab_names.map{|tab_name| tab_opts(tab_name, media[tab_name] || [])}
  end
  
  private 
  
  def tab_opts(tab_name, assets)
    title = tab_name.to_s.capitalize
    {
      title: title,
      content: (tab_name == :programs) ?
        render(partial: 'override/partials/asset_table_programs', locals: { assets: assets.sort_by {|p| p.episode.to_i} } )
        : render(partial: 'override/partials/asset_table', locals: { assets: assets } )
    }
  end
  
  def lookup_media(id_or_slug)
    series = lookup(id_or_slug)[:ov_asset]
    programs = series.programs
    videos = series.videos + programs.map{|p| p.videos}.flatten
    audios = series.audios + programs.map{|p| p.audios}.flatten
    media = videos + audios
    images = series.images + programs.map{|p| p.images}.flatten
    {
      programs: programs,
      videos: videos,
      audios: audios,
      media: media,
      images: images
    }
  rescue Blacklight::Exceptions::InvalidSolrID
    logger.error("Failed to find '#{id_or_slug}': tabs on that series page will be empty.")
    {}
  end
  
  # TODO: started as copy-and-paste from lookup_by_slug.
  # Need to figure out a better way of doing this: Requiring
  # that module as-is caused lots of problems at Rails start up.
  def lookup id_or_slug
    
    # first try searching the 'id' field
    item = Blacklight.solr.select(params: {q: "id:#{id_or_slug}"})
    
    # search by 'slug' field if searching by 'id' field returned no results.
    item = Blacklight.solr.select(params: {q: "slug:#{id_or_slug}"}) if (item['response']['numFound'] == 0)

    # raise an exception if nothing was found.
    raise Blacklight::Exceptions::InvalidSolrID unless item['response']['docs'].first

    document = item['response']['docs'].first
    ov_asset = ActiveFedora::Base.find(document['id'], cast: true) rescue nil 
    {   
      response: response,
      document: document,
      ov_asset: ov_asset
    }   
  end 
  
end