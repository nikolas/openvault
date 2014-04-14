ActiveAdmin.register Org, as: "Organization" do

  index do
    column :name
    column "Description", :desc do |org|
      truncate(org.desc, :length => 50)
    end
    column "Users" do |org|
      raw sorted_user_links(org.users).join(', ')
    end
    actions
  end

  show do |org|
    attributes_table do
      row :name
      row "Description" do
        org.desc
      end
      row :users do |org|
        raw sorted_user_links(org.users).join(', ')
      end

    end

    # active_admin_comments

  end

  form do |f|

    f.inputs "Details" do
      f.input :name
      f.input :desc
      f.input :users, as: :select, input_html: {multiple: true}
    end
    f.actions
  end
  
end
