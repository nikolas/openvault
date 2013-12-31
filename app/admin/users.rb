ActiveAdmin.register User do
  
  #we don't need the admin comments for users
  config.comments = false
  
  #this will turn off the sidebar
  #config.clear_sidebar_sections!
  
  #filters (only a select few are needed but uncomment out the below line if more are needed)
  #preserve_default_filters!
  filter :email
  filter :first_name
  filter :last_name
  filter :role, :as => :select, :collection => [['member', 'member'], ['scholar', 'scholar']]
  
  #overrides the index view. remove :download_links => false if you want the download links
  index :download_links => false do
    column :id
    column :first_name
    column :last_name
    column :email
    column "Organizations" do |user|
      raw sorted_org_links(user.orgs).join(', ')
    end
    column :role
    actions
  end
  
  #overrides the view page format
  show do |user|
    attributes_table do
      row :avatar do
        image_tag(user.avatar)
      end
      row :first_name
      row :last_name
      row :email
      row "Organizations" do
        raw sorted_org_links(user.orgs).join(', ')
      end
      row :postal_code
      row :country
      row :mla_updates
      row :role
    end
  end
  
  #overrides the edit/new form
  form(:html => {:multipart => true}) do |f|
    f.inputs "Details" do
      f.input :avatar, as: :file
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :orgs, as: :select, input_html: {multiple: true}
      f.input :password
      f.input :password_confirmation
      f.input :postal_code
      f.input :country
      f.input :mla_updates
      f.input :terms_and_conditions
      f.input :role, :as => :select, :collection => [['member', 'member'], ['scholar', 'scholar']]
    end
    f.actions
  end
  
  controller do
    # This code is evaluated within the controller class and overrides the exisiting methods if they are the same
    def update
       @user = User.find(params[:id])
       if params[:user][:password].blank?
         @user.update_without_password(params[:user])
       else
         @user.update_attributes(params[:user])
       end
       if @user.errors.blank?
         redirect_to admin_users_path, :notice => "User updated successfully."
       else
         render :edit
       end
     end
  end
  
end
