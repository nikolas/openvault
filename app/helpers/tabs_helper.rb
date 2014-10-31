module TabsHelper
  
  def tab_opts(title,assets)
    { title: title, content: render(partial: 'override/partials/asset_table', locals: { assets: assets } ) }
  end
  
  def tabs_for(slug,tab_names)
    media = lookup_media(slug)
    tab_names.map{|tab_name| tab_opts(tab_name.to_s.capitalize, media[tab_name] || [])}
  end
  
  private 
  
  def lookup_media(slug)
    series = lookup(slug)[:ov_asset]
    if series
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
    else
      {}
    end
  end
  
  # TODO: started as copy-and-paste from lookup_by_slug.
  # Need to figure out a better way of doing this: Requiring
  # that module as-is caused lots of problems at Rails start up.
  def lookup id
    item = Blacklight.solr.select(params: {q: "id:#{id}"})
    raise 'could not find solr document' unless item['response']['docs'].first
    document = item['response']['docs'].first
    pid = document[:pid] || document['pid'] || id rescue id
    ov_asset = ActiveFedora::Base.find(pid, cast: true) rescue nil 
    {   
      response: response,
      document: document,
      ov_asset: ov_asset
    }   
  end 
  
end