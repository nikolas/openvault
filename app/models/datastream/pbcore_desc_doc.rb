class PbcoreDescDoc < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: "pbcoreDescriptionDocument")

    t.all_ids(path: "pbcoreIdentifier", index_as: [:symbol]) {
      t.source(path: {attribute: 'source'})
    }

    t.original_file_name(path: 'pbcoreInstantiation/instantiationIdentifier[@source="Original file name"]')
    
    # Terminology for <pbcoreTitle>

    t.series_title(path: "pbcoreTitle", attributes: { titleType: "Series"})

    t.program_title(path: "pbcoreTitle", attributes: {titleType: "Program"})

    t.episode_title(path: "pbcoreTitle", attributes: { titleType: "Episode" })

    t.image_title(path: "pbcoreTitle", attributes: { titleType: "Image" })

    # Term for inspecting all the titles present in the XML.
    t.all_titles(path: "pbcoreTitle") {
      t.type(path: {attribute: 'titleType'})
    }

    t.asset_type(path: "pbcoreAssetType")

    t.broadcast_date(path: "pbcoreAssetDate", attributes: {dateType: "broadcast"})
    
    # Creator names and roles
    t.creator(path: "pbcoreCreator") do
      t.creator
      t.role_(path: "creatorRole")
    end
    t.creator_name(ref: [:creator, :creator], type: :string)
    t.creator_role(ref: [:creator, :role], type: :string)

    t.all_descriptions(path: 'pbcoreDescription') {
      t.type(path: {attribute: 'descriptionType'})
    }

    t.rights(path: 'pbcoreRightsSummary/rightsEmbedded/WGBH_RIGHTS') {
      t.rights(path: '@RIGHTS')
      t.coverage(path: '@RIGHTS_COVERAGE')
      t.credit(path: '@RIGHTS_CREDIT')
      t.holder(path: '@RIGHTS_HOLDER')
      t.note(path: '@RIGHTS_NOTE')
      t.type(path: '@RIGHTS_TYPE')
    }
    
    t.contributors(path: 'pbcoreContributor') {
      t.name(path: 'contributor')
      t.affiliation(path: 'contributor/@affiliation')
      t.role(path: 'contributorRole')
    }
        
    t.barcode(path: 'pbcoreRelation[pbcoreRelationType[@source="SOURCE"]="Tracking Number"]/pbcoreRelationIdentifier')
    # <pbcoreRelation>
    #   <pbcoreRelationType source="SOURCE">Tracking Number</pbcoreRelationType>
    #   <pbcoreRelationIdentifier>50013</pbcoreRelationIdentifier>
    # </pbcoreRelation>
    
    
    t.subjectsNotNested(path: 'pbcoreSubject[not(subjectAuthorityUsed)]')
    t.subjectsNested(path: 'pbcoreSubject/subject')
    # Tried xPath union to combine these, but it didn't work.
    
    t.instantiation(path: 'pbcoreInstantiation') {
      t.dimensions(path: 'instantiationDimensions')
      t.physical(path: 'instantiationPhysical')
      t.standard(path: 'instantiationStandard')
      t.duration(path: 'instantiationDuration')
      t.media_type(path: 'instantiationMediaType')
      t.digital(path: 'instantiationDigital')
      t.id(path: 'instantiationIdentifier') {
        t.source(path: {attribute: 'source'})
      }
    }
    
    # Relations
    t.relations(path: 'pbcoreRelation') {
      t.type(path: 'pbcoreRelationType')
      t.id(path: 'pbcoreRelationIdentifier')
    }

    # Coverage
    t.coverage(path: 'pbcoreCoverage') {
      t.date_portrayed(path: 'coverage', attributes: { ref: "DATE_PORTRAYED" })
      t.type(path: 'coverageType')
    }

    # Publisher
    t.publishers(path: 'pbcorePublisher') {
      t.name(path: 'publisher')
      t.role(path: 'publisherRole')
    }

  end

  def self.xml_template
    Nokogiri::XML('<pbcoreDescriptionDocument />')
  end

  def titles_by_type
    titles = {}
    for i in 0..(self.all_titles.count - 1)
        titles[self.all_titles(i).type.first] = self.all_titles[i]
    end
    titles
  end

  def ids_by_source
    ids = {}
    for i in 0..(self.all_ids.count - 1)
      ids[self.all_ids(i).source.first] = self.all_ids[i]
    end
    ids
  end

  # relations_by_type
  # Returns a hash of values from <pbcoreRelationIdentifier> nodes keyed by values from <pbcoreRelationType> nodes.
  def relations_by_type
    relations = {}
    for i in 0..(self.relations.count-1)
      type = self.relations(i).type.first
      relations[type] ||= []
      relations[type] += self.relations(i).id
    end
    relations
  end
  
  def contributions_by_role
    contributions = {}
    for i in 0..(self.contributors.count-1)
      contributor = self.contributors(i)
      name = contributor.name.first
      affiliation = contributor.affiliation.first
      compound = affiliation ? "#{name} [#{affiliation}]" : name
      contributor.role.map{|r| r.gsub(/\d+$/,'')}.each do |r| 
        contributions[r] ||= []
        contributions[r] << compound
      end
    end
    contributions
  end

  def digital
    return self.instantiation.digital.first
  end

  # publisher_names_and_roles
  # Returns an array of hashes. Each hash has two keys: 'name' and 'role', which correspond to each <publisher> and <publisherRole> pair.
  def publisher_names_and_roles
    publishers = []
    for i in 0..(self.publishers.count-1)
      publisher = {
        name: self.publishers(i).name.first,
        role: self.publishers(i).role.first
      }
      publishers << publisher
    end
    publishers
  end
end
