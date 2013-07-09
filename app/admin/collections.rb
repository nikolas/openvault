ActiveAdmin.register Collection do
  
  config.comments = false
  
  config.clear_sidebar_sections!
  
  index do
    column :name
    column "Summary", :summary do |collection|
      truncate(collection.summary, :length => 50)
    end
    column "Image", :full_image do |collection|
      image_tag collection.image.url(:thumb)
    end
    column :order_number
    column :display_in_carousel
    actions
  end
  
end
