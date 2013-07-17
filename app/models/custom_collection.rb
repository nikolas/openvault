class CustomCollection < ActiveRecord::Base
  attr_accessible :article, :image, :name, :summary, :user_id
  
  validates_presence_of :name, :on => :create, :message => "can't be blank"
  validates_presence_of :summary, :on => :create, :message => "can't be blank"
  validates_presence_of :user_id, :on => :create, :message => "can't be blank"
  validate :user_id_scholar
  
  belongs_to :user
  
  mount_uploader :image, CustomCollectionImageUploader
  mount_uploader :article, CustomCollectionArticleUploader
  
  def user_can_edit?(user)
    self.user_id == user.id
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
  
end
