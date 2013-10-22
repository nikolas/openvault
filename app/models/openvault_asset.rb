require 'artesia/datastream/uois'

class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'uois', :type => Artesia::Datastream::UOIS
  has_metadata 'pbcore', :type => PbcoreDescDoc

  has_file_datastream 'source_xml'

  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  #don't think this is working
  has_many :custom_collection_items, :property => :is_part_of
  
  include Sufia::GenericFile
  
  def accept_annotations
    #logic will go here to accept annotations from scholars
  end
  
  def to_solr(solr_document={}, options={})
    super(solr_document, options)
    solr_document["slug"] = self.noid
    Solrizer.insert_field(solr_document, "sort_date", self.pbcore.asset_date.first, :sortable)
    Solrizer.insert_field(solr_document, "sort_title", self.pbcore.title.first, :sortable)
    Solrizer.insert_field(solr_document, "display_title", self.title, :sortable, :displayable, :searchable)
    Solrizer.insert_field(solr_document, "display_summary", self.summary, :displayable, :searchable)
    return solr_document
  end
  
  def media
    #get the media assets for the program
    media = new Array
    media["audios"] << self.audios
    media["videos"] << self.videos
    media["transcripts "] << self.transcripts
  end
  
  def kind
    if is_series?
      'series'
    elsif is_program?
      'program'
    elsif is_item?
      'item'
    end
  end
  
  private
  
  #How best to determine these
  def is_series?
    false
  end
  
  def is_program?
    false
  end
  
  def is_collection?
    false
  end
  
  def is_clip?
    false
  end
  
  def is_element?
    false
  end
  
  def is_item?
    true
  end
  
end
