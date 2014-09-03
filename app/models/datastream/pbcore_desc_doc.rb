class PbcoreDescDoc < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    t.all_ids(:path => "pbcoreIdentifier", :index_as => [:stored_searchable]) {
      t.source(:path => {:attribute => 'source'})
    }

    # Terminology for <pbcoreTitle>

    t.series_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Series"})

    t.program_title(:path => "pbcoreTitle", :attributes=>{:titleType=>"Program"})

    t.chapter_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Chapter" })

    t.episode_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Episode" })
    
    t.element_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Element" })
    
    t.clip_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Clip" })
    
    t.label(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Label" })
    
    t.segment_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Segment" })
    
    t.subtitle(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Subtitle" })
    
    t.track_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Track" })

    t.image_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Image" })

    t.translation_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Translation" })

    # Term for inspecting all the titles present in the XML.
    t.all_titles(:path => "pbcoreTitle") {
      t.type(:path => {:attribute => 'titleType'})
    }

    t.asset_type(:path => "pbcoreAssetType")


    t.category(:path=>"pbcoreSubject", :attributes=>{:subjectType=>"Category"})

    # Terminology for <pbcoreDescription>

    t.summary(:path => 'pbcoreDescription', :attributes => {:descriptionType => "Summary"})
    
    # Creator names and roles
    t.creator(:path=>"pbcoreCreator") do
      t.creator
      t.role_(:path=>"creatorRole")
    end
    t.creator_name(:ref=>[:creator, :creator], :type => :string)
    t.creator_role(:ref=>[:creator, :role], :type => :string)

    t.all_descriptions(:path => 'pbcoreDescription') {
      t.type(:path => {:attribute => 'descriptionType'})
    }

    t.rights(:path => 'pbcoreRightsSummary/rightsEmbedded/WGBH_RIGHTS') {
      t.rights(:path => '@RIGHTS')
      t.coverage(:path => '@RIGHTS_COVERAGE')
      t.credit(:path => '@RIGHTS_CREDIT')
      t.holder(:path => '@RIGHTS_HOLDER')
      t.note(:path => '@RIGHTS_NOTE')
      t.type(:path => '@RIGHTS_TYPE')
    }
    
    t.instantiations(:path => "pbcoreInstantiation") {
      t.media_type(:path => 'instantiationMediaType')
      t.digital(path: 'instantiationDigital')
      t.id(:path => 'instantiationIdentifier') {
        t.source(:path => {:attribute => 'source'})
      }
    }

    # Relations
    t.relations(:path => 'pbcoreRelation') {
      t.type(:path => 'pbcoreRelationType')
      t.id(:path => 'pbcoreRelationIdentifier')
    }

    # Coverage
    t.coverage(path: 'pbcoreCoverage') {
      t.date_portrayed(path: 'coverage', :attributes=>{ ref: "DATE_PORTRAYED" })
      t.type(path: 'coverageType')
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

  def digital
    return self.instantiations.digital.first
  end
end
