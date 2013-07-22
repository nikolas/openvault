class CustomCollection < ActiveRecord::Base
  attr_accessible :article, :image, :name, :summary, :user_id, :slug
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :summary, :on => :create, :message => "can't be blank"
  validates_presence_of :user_id, :on => :create, :message => "can't be blank"
  validate :user_id_scholar
  
  belongs_to :user
  has_many :custom_collection_items
  
  before_save :is_new
  before_save :create_slug
  
  mount_uploader :image, CustomCollectionImageUploader
  mount_uploader :article, CustomCollectionArticleUploader
  
  def user_can_edit?(user)
    self.user_id == user.id
  end
  
  def van_url
    "/scholar/#{self.user.username}/#{self.slug}"
  end
  
  private
  
  def user_id_scholar
    if self.user_id.nil?
      false
    else
      user = User.find(self.user_id)
      errors.add(:user_id, 'only scholars can create custom collections') unless user.is_scholar?
    end
  end
    
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
