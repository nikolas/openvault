class Collection < ActiveRecord::Base
  attr_accessible :name, :summary, :image, :position, :display_in_carousel, :slug
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :summary, :on => :create, :message => "can't be blank"
  validates_presence_of :display_in_carousel, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :name, :on => :create, :message => "must be unique"
  
  mount_uploader :image, CollectionImageUploader
  
  before_save :is_new
  before_save :create_slug
  
  acts_as_list
  
  def url
    "/collections/#{self.slug}"
  end
  
  private
  
  def is_new
    @was_a_new_record = new_record?
    return true
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
