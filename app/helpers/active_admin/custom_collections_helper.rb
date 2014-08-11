module ActiveAdmin::CustomCollectionsHelper

  def scholar_owner_options
    scholar_options = User.scholars.map { |scholar| [scholar.last_name_first, "#{scholar.class}:#{scholar.id}"] }
    scholar_options.sort_by! { |option| option.first }
  end

  def org_owner_options
    org_options = Org.all.map { |org| [org.name, "#{org.class}:#{org.id}"] }
    org_options.sort_by! {|option| option.first }
  end

  def owner_option_text(owner_type_and_id)
    all_owner_options = scholar_owner_options + org_owner_options
    selected_owner_option = all_owner_options.select { |option| option.last == custom_collection.owner_type_and_id }.first
    selected_owner_option.first
  end
end