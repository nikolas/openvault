module ActiveAdmin::ViewsHelper
  def sorted_org_links(orgs)
    sorted_orgs = orgs.sort_by{ |org| org.name }
    sorted_org_links = sorted_orgs.map{ |org| link_to org.name, admin_organization_path(org.id) }
  end

  def sorted_user_links(users)
    sorted_users = users.sort_by{ |user| user.full_name }
    sorted_user_links = sorted_users.map{ |user| link_to user.full_name, admin_user_path(user.id) }
  end
end