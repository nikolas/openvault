module AffiliationsHelper

   def work_string(user)
    if user.primary_title.blank? && user.primary_organization.blank?
      ""
    elsif user.primary_title.blank? && user.primary_organization.present?
      "works at #{user.primary_organization}"
    elsif user.primary_title.present? && user.primary_organization.blank?
      raise "User must have an organization to have a title."
    else
      "#{user.primary_title} at #{user.primary_organization}"
    end
  end 
end
