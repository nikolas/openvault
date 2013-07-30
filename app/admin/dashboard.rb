ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      
      column do
        panel "Recent Collections" do
          ul do
            Collection.limit(15).map do |post|
              li link_to(post.name, admin_collection_path(post))
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
          para "Welcome to ActiveAdmin #{current_admin_user.email}."
        end
      end
      
    end
    
  end # content
end
