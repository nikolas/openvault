class PbcoreDescDoc < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

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

    t.asset_date(:path=>"pbcoreAssetDate", :type => :string)

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

    t.instantiations(:path => "pbcoreInstantiation") {
      t.media_type(:path => 'instantiationMediaType')
    }

  end

  def self.xml_template
    Nokogiri::XML('<pbcoreDescriptionDocument />')
  end

  def titles_by_type
    titles = {}
    for i in 0..self.all_titles.count
        titles[self.all_titles(i).type.first] = self.all_titles[i]
    end
    titles
  end
end