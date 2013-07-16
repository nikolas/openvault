ActiveAdmin.register MosaicItem do
  config.comments = false
  config.clear_sidebar_sections!
  
  form do |f|
    f.inputs "Slug Content" do
      f.input :slug
      f.input :link_title
      f.actions
    end
  end
end
