ActiveAdmin.register Collection do
  
  config.comments = false
  config.paginate   = false
  config.clear_sidebar_sections!
  
  # action_item do
#     link_to "All Collections", all_admin_collections_path
#   end
#   action_item do
#     link_to "Carousel Collections", admin_collections_path
#   end
  
  config.sort_order = "position_asc"
  
  # collection_action :all, :method => :get do
#     
#     scope = Collection.unscoped
# 
#     @collection = scope.page() if params[:q].blank?
#   end
  
  
  index do
    column :name
    column "Summary", :summary do |collection|
      truncate(collection.summary, :length => 50)
    end
    column "Image", :full_image do |collection|
      image_tag collection.image.url(:thumb)
    end
    column :display_in_carousel
    default_actions
  end
  
  collection_action :sort, :method => :post do
    puts params.inspect
    params[:collection].each_with_index do |id, index|
      Collection.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
  # index :as => :block do |collection| 
  #   div :for => collection, :style => 'height: 200px;border-bottom: 1px solid #aaa;padding-bottom:15px;margin-bottom:15px;' do
  #     a href: admin_collection_path(collection) do
  #       img src: collection.image.url(:med), style: 'float:left; margin-right:15px;'
  #     end
  #     h2 do
  #       a href: admin_collection_path(collection) do
  #         collection.name
  #       end
  #     end
  #     div do
  #       simple_format truncate(collection.summary, :length => 500)
  #     end
  #     div class: 'actions' do
  #       link_to "Edit", edit_admin_collection_path(collection)
  #     end
  #   end
  # end
  
  # show do
  #   #render 'app/views/admin/collections/show.html.erb'
  #   render "show"
  # end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :display_in_carousel
      f.input :image
    end
    f.inputs "Content" do
      f.input :summary
      f.input :mid_content, as: :html_editor, label: 'Browse content'
      f.input :lower_content, as: :html_editor, label: 'Related links'
    end
    f.actions
  end
  
end
