ActiveAdmin.register CustomCollection do
	config.filters = true

	index do
    column :name
    column :summary
    column :owner
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :name
      f.input :summary
      f.input :owner_type_and_id, as: :select, collection: grouped_options_for_select({"Organizations" => org_owner_options, "Scholars" => scholar_owner_options}, f.object.owner_type_and_id)
      f.input :slug
    end

    f.inputs do
      f.input :collabs,  as: :check_boxes, collection: User.scholars.sort_by {|scholar| scholar.last_name_first}, member_label: :last_name_first
    end

    f.inputs do
      f.has_many :custom_collection_images, allow_destroy: true, heading: 'Images', new_record: true do |cc_img|
        cc_img.input :image, as: :file
        cc_img.input :alt_text
        cc_img.input :rights
      end
    end

    f.actions
  end

  member_action :add_collaborator, :method => :post do
    redirect_to :action => :show, :notice => "Added collaborator"
  end

  show do |custom_collection|
  	attributes_table do
	  	row :id
	  	row :name
	  	row :summary
	  	row :article
	  	row :created_at
	  	row :updated_at
	  	row :owner
	  	row :slug
	  	row :owner_type
  	end

    panel "Collaborators" do
      if custom_collection.collabs.present?
        table_for custom_collection.collabs do
          column(:last_name) {|c| c.last_name}
          column(:first_name) {|c| c.first_name}
          column(:email) {|c| c.email}
          column(:role) {|c| c.role}
        end
      else
        "None"
      end
    end

    panel "Images" do
      if custom_collection.custom_collection_images.present?
        table_for custom_collection.custom_collection_images do
          column(:image) { |cc_img| image_tag(cc_img.image.small, alt: cc_img.alt_text) }
        end
      else
        "None"
      end
    end
  end

end
