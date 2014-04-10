ActiveAdmin.register CustomCollection do
	config.filters = true

	index do
    column :name
    column :summary
    actions
  end

  # action_item :only => :show do
     # link_to "Add Collaborator", ""
  # end

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
          column :action do |c|
            link_to "Remove", ""
          end
        end
      else
        "None"
      end
    end

    panel "Add Collaborator" do
      "ADD DROPDOWN AND BUTTON"
    end
  end
end
