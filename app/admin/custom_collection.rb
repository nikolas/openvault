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
      f.input :image, :as => :file
      f.input :owner_id, :as => 'select', :collection => User.scholars + Org.all
      f.input :owner_type, :collection => ['User', 'Org']
      f.input :slug
    end
    f.inputs do
      f.input :collabs,  :as => :check_boxes, :collection => User.all
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
	  	row :image
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
          column(:id) {|c| c.id}
          column(:first_name) {|c| c.first_name}
          column(:last_name) {|c| c.last_name}
          column(:email) {|c| c.email}
          column(:role) {|c| c.role}
        end
      else
        "None"
      end
    end
  end
end
