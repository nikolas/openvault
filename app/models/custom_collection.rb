class CustomCollection < ActiveRecord::Base
  attr_accessible :article, :name, :summary, :owner, :owner_id, :owner_type, :slug, :credits, :article_rights, :custom_collection_images_attributes, :custom_collection_images, :custom_collection_related_links, :custom_collection_related_links_attributes, :image, :collabs_attributes, :collab_ids
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :summary, :on => :create, :message => "can't be blank"
  validate :validate_owner
  
  # :owner can be one of multiple models, including User and Org
  belongs_to :owner, polymorphic: true

  has_many :custom_collection_items, :dependent => :destroy
  has_many :custom_collection_related_links, :dependent => :destroy
  has_many :custom_collection_images, :dependent => :destroy

  has_many :custom_collection_collabs
  has_many :collabs, through: :custom_collection_collabs, source: :user
  
  accepts_nested_attributes_for :custom_collection_items
  accepts_nested_attributes_for :custom_collection_related_links, :allow_destroy => true, :reject_if => lambda { |a| a[:desc].blank? || a[:link].blank? }
  accepts_nested_attributes_for :custom_collection_images, :allow_destroy => true, :reject_if => lambda { |a| a[:image].blank? }
  
  before_save :is_new
  before_save :create_slug
  after_save :is_pdf_new?
  
  mount_uploader :article, CustomCollectionArticleUploader

  accepts_nested_attributes_for :collabs

  def has_item?(id)
    custom_collection_items.map{|c| c.openvault_asset_pid}.include?(id)
  end
  
  def add_collection_item(item, kind)
    CustomCollectionItem.create(:openvault_asset_pid => item, :kind => kind, :custom_collection_id => self.id)
  end
  
  def remove_collection_item(item)
    CustomCollectionItem.where(openvault_asset_pid: item, custom_collection_id: self.id).delete_all
  end

  def owner_name
    if self.owner.is_a? User
      self.owner.full_name
    elsif self.owner.is_a? Org
      self.owner.name
    end
  end
  

  def poster_image
    custom_collection_images.first.image.url(:med) unless custom_collection_images.empty?
  end

  
  private

  def validate_owner
    if (self.owner.nil?) || !(self.owner.is_a?(User) || self.owner.is_a?(Org)) || (self.owner.is_a?(User) && !self.owner.is_scholar?)
      errors.add(:owner, "must be a Scholar or an Organization")
    end
  end
    
  def is_new
    @was_a_new_record = new_record?
    return true
  end
  
  def is_pdf_new?
    #only do this when the article has changed.  this uses Dirty Model
    if self.article_changed? && self.article.file.extension.downcase == 'pdf'
      reader = PDF::Reader.new(self.article.path)
      reader.pages.each do |page|
        #this is where a callback will go to send to solr index
      end
    end
  end

  def create_slug
    if @was_a_new_record || self.slug.blank?
      ret = self.name.strip.downcase
      #blow away apostrophes
      ret.gsub! /['`]/,""
      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "
      #replace all non alphanumeric, underscore or periods with underscore
      ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'  
      #convert double underscores to single
      ret.gsub! /_+/,"-"
      #strip off leading/trailing underscore
      ret.gsub! /\A[_\.]+|[_\.]+\z/,""
      
      self.slug = ret
    end
  end
 
end
