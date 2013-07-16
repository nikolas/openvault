ActiveAdmin.register Collection do
  
  config.comments = false
  config.paginate   = false
  config.clear_sidebar_sections!
  sortable
  
  action_item do
    link_to "All Collections", all_admin_collections_path
  end
  action_item do
    link_to "Carousel Collections", admin_collections_path
  end
  
  controller do
    def scoped_collection
      Collection.where(display_in_carousel: true)
    end
  end
  config.sort_order = "position_asc"
  
  collection_action :all, :method => :get do
    
    scope = Collection.unscoped

    @collection = scope.page() if params[:q].blank?
    #@search = scope.metasearch(clean_search_params(params[:q]))

    # respond_to do |format|
#       format.html {
#         render "active_admin/resource/index"
#       }
#     end
  end
  
  
  index do
    sortable_handle_column
    column :name
    column "Summary", :summary do |collection|
      truncate(collection.summary, :length => 50)
    end
    column "Image", :full_image do |collection|
      image_tag collection.image.url(:thumb)
    end
    column :position
    column :display_in_carousel
    actions
  end
  
  index :as => :block do |collection| 
    div :for => collection, :style => 'height: 140px;border-bottom: 1px solid #aaa;padding-bottom:15px;margin-bottom:15px;' do
      a href: admin_collection_path(collection) do
        img src: collection.image.url(:med), style: 'float:left; margin-right:15px;'
      end
      h2 do
        a href: admin_collection_path(collection) do
          collection.name
        end
      end
      div do
        simple_format truncate(collection.summary, :length => 500)
      end
      div class: 'actions' do
        link_to "Edit", edit_admin_collection_path(collection)
      end
    end
  end
  
  # show do
#     # renders app/views/admin/collections/_show.html.erb
#     render "show"
#   end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :display_in_carousel
      f.input :image
    end
    f.inputs "Content" do
      f.input :summary
    end
    f.actions
  end
  
end
