module AffiliationsHelper

  def primary_organization(user)
    user.affiliations.each do |affiliation|
      if affiliation.primary 
        return Org.find(affiliation.org_id).name
      end
    end
  end

  def primary_organization_title(user)
    user.affiliations.each do |affiliation|
      if affiliation.primary
        return affiliation.title
      end
    end
  end

end
