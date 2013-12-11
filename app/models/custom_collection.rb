class CustomCollection < ActiveRecord::Base
  attr_accessible :article, :image, :name, :summary, :owner, :owner_id, :owner_type, :slug, :credits, :article_rights, :custom_collection_images_attributes, :custom_collection_images, :custom_collection_related_links, :custom_collection_related_links_attributes
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :summary, :on => :create, :message => "can't be blank"
  validates_presence_of :owner_id, :on => :create, :message => "can't be blank you fool!!!"
  validate :owner_id_scholar
  
  belongs_to :owner, polymorphic: true
  has_many :custom_collection_items, :dependent => :destroy
  has_many :custom_collection_related_links, :dependent => :destroy
  has_many :custom_collection_images, :dependent => :destroy
  
  accepts_nested_attributes_for :custom_collection_items
  accepts_nested_attributes_for :custom_collection_related_links, :allow_destroy => true, :reject_if => lambda { |a| a[:desc].blank? || a[:link].blank? }
  accepts_nested_attributes_for :custom_collection_images, :allow_destroy => true, :reject_if => lambda { |a| a[:image].blank? }
  
  before_save :is_new
  before_save :create_slug
  after_save :is_pdf_new?
  
  mount_uploader :article, CustomCollectionArticleUploader
  
  def user_can_edit?(user)
    self.owner_id == user.id
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
    else
      ""
    end
  end
  
  
  private
  
  # There might be a better way to determine abilitiy to create.
  def owner_id_scholar
    if self.owner_id.nil? || self.owner_type != "User"
      false
    else
      user = User.find(self.owner_id)
      errors.add(:owner_id, 'only scholars can create custom collections') unless user.is_scholar?
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
