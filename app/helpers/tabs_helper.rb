module TabsHelper
  
  def tab_opts(title,assets)
    { title: title, content: render(partial: 'override/partials/asset_table', locals: { assets: assets } ) }
  end
  
end