ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      
      column do
        panel "Custom Collections" do
          ul do
            CustomCollection.all.map do |custom_collection|
              li link_to(custom_collection.name, admin_custom_collection_path(custom_collection))
            end
          end
        end
      end
      
      column do
        panel "Recent Users" do
          ul do
            User.limit(15).map do |user|
              li link_to(user.full_name, admin_user_path(user))
            end
          end
        end
      end

      column do
        panel "Info" do
          para "Welcome to ActiveAdmin #{current_user.email}."
        end
      end
      
    end
    
  end # content
end
