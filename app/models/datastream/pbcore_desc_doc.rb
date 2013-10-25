class PbcoreDescDoc < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    # Terminology for <pbcoreTitle>

    t.series_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Series"}, :index_as => [:facetable, :stored_searchable, :displayable])

    t.program_title(:path => "pbcoreTitle", :attributes=>{:titleType=>"Program"}, :index_as => [:facetable, :stored_searchable, :displayable])

    t.chapter_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Chapter" }, :index_as => [:facetable, :stored_searchable, :displayable])

    t.episode_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Episode" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.element_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Element" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.clip_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Clip" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.label(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Label" }, :index_as => [:stored_searchable, :displayable])
    
    t.segment_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Segment" }, :index_as => [:stored_searchable, :displayable])
    
    t.subtitle(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Subtitle" }, :index_as => [:stored_searchable, :displayable])
    
    t.track_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Track" }, :index_as => [:stored_searchable, :displayable])
    
    t.item_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Item" }, :index_as => [:stored_searchable, :displayable])

    t.image_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Image" }, :index_as => [:stored_searchable, :displayable])

    t.translation_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Translation" }, :index_as => [:stored_searchable, :displayable])

    # Term for inspecting all the titles present in the XML.
    t.all_titles(:path => "pbcoreTitle") {
      t.type(:path => {:attribute => 'titleType'})
    }

    t.asset_type(:path => "pbcoreAssetType")


    t.category(:path=>"pbcoreSubject", :attributes=>{:subjectType=>"Category"},:index_as => [:facetable, :displayable])

    t.asset_date(:path=>"pbcoreAssetDate", :type => :string, :index_as => [:facetable, :stored_searchable, :displayable])

    # Terminology for <pbcoreDescription>

    t.summary(:path => 'pbcoreDescription', :attributes => {:descriptionType => "Summary"}, :index_as => [:stored_searchable, :displayable])
    
    # Creator names and roles
    t.creator(:path=>"pbcoreCreator") do
      t.creator
      t.role_(:path=>"creatorRole")
    end
    t.creator_name(:ref=>[:creator, :creator], :type => :string, :index_as => [:stored_searchable, :displayable])
    t.creator_role(:ref=>[:creator, :role], :type => :string, :index_as => [:stored_searchable, :displayable])

    t.all_descriptions(:path => 'pbcoreDescription', :index_as => [:stored_searchable, :displayable]) {
      t.type(:path => {:attribute => 'descriptionType'})
    }

    t.instantiations(:path => "pbcoreInstantiation") {
      t.media_type(:path => 'instantiationMediaType')
    }

  end

  def self.xml_template
    Nokogiri::XML('<pbcoreDescriptionDocument />')
  end
end