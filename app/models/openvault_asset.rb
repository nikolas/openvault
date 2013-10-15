require 'hydra-pbcore'
require 'artesia/datastream/uois'

class OpenvaultAsset < ActiveFedora::Base
  include Blacklight::SolrHelper

  has_metadata 'uois', :type => Artesia::Datastream::UOIS
  has_metadata 'pbcore', :type => HydraPbcore::Datastream::Document

  has_file_datastream 'source_xml'

  belongs_to :artesia_ingest, :property => :is_part_of, :class_name => 'ArtesiaIngest'
  
  #don't think this is working
  has_many :custom_collection_items, :property => :is_part_of
  
  include Sufia::GenericFile
  
  def title
    if is_series?
      title = self.pbcore.series.first
    elsif is_program?
      title = self.pbcore.program.first
    elsif is_collection?
      title = self.pbcore.collection.first
    elsif is_clip?
      title = self.pbcore.clip.first
    elsif is_element?
      title = self.pbcore.element.first
    elsif is_item?
      title = self.pbcore.item.first
    else
      title = "Openvault Asset #{self.noid}"
    end
  end
  
  def summary
    if is_series?
      title = self.pbcore.series.first
    elsif is_program?
      title = self.pbcore.program.first
    elsif is_collection?
      title = self.pbcore.collection.first
    elsif is_clip?
      title = self.pbcore.clip.first
    elsif is_element?
      title = self.pbcore.element.first
    elsif is_item?
      title = self.pbcore.item.first
    else
      title = "<p>Donec congue lacinia dui, a porttitor lectus condimentum laoreet. Nunc eu ullamcorper orci. Quisque eget odio ac lectus vestibulum faucibus eget in metus. In pellentesque faucibus vestibulum. Nulla at nulla justo, eget luctus tortor. Nulla facilisi. Duis aliquet egestas purus in blandit. Curabitur vulputate, ligula lacinia scelerisque tempor, lacus lacus ornare ante, ac egestas est urna sit amet arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed molestie augue sit amet leo consequat posuere.</p>"
    end
  end
  
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
