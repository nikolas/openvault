class CustomCollectionItem < ActiveRecord::Base
  
  attr_accessible :annotations, :cat_slug, :custom_collection_id, :openvault_asset_pid, :kind
  
  belongs_to :custom_collection
  #don't think this is working
  #belongs_to :openvault_asset, :foreign_key => :openvault_asset_pid
  
  validates_presence_of :openvault_asset_pid, :on => :create, :message => "can't be blank"
  validates_presence_of :kind, :on => :create, :message => "can't be blank"
  validates_presence_of :custom_collection_id, :on => :create, :message => "can't be blank"
  
  serialize :annotations, HashWithIndifferentAccess
  
  scope :videos, where(:kind => 'Video')
  scope :audios, where(:kind => 'Audio')
  scope :programs, where(:kind => 'Program')
  scope :series, where(:kind => 'Series')
  
  def ov_asset
    item = Blacklight.solr.get('select', :params => {:q => "slug:#{self.openvault_asset_pid}"})
    item['response']['docs'].first
  end
  
end
