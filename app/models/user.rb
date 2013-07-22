class User < ActiveRecord::Base
# Connects this user object to Hydra behaviors. 
 include Hydra::User
# Connects this user object to Blacklights Bookmarks. 
 include Blacklight::User
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :postal_code, :country, :mla_updates, 
                  :terms_and_conditions, :role, :username, :bio, :title, :organization, :avatar
                  
  has_many :custom_collections

  validates :terms_and_conditions, acceptance: {allow_nil: false, accept: true, on: :create}
  validates_presence_of :first_name, :message => "can't be blank"
  validates_presence_of :last_name, :message => "can't be blank"
  validates_presence_of :postal_code, :message => "can't be blank"
  validates_presence_of :country, :message => "can't be blank"
  validates_uniqueness_of :email, :message => "must be unique"
  validates_presence_of :role, :message => "can't be blank"
  validates_inclusion_of :role, :in => %w( member scholar ), :on => :create, :message => "role %s is not included in the list"
  validates_length_of :bio, :within => 0..500, :on => :create, :message => "must be less at least 3 and no more than 500 characters"
  
  mount_uploader :avatar, AvatarUploader

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account. 
  def to_s
    email
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def work_string
    if self.title.blank? && self.organization.blank?
      ""
    elsif self.title.blank? && !self.organization.blank?
      "works at #{self.organization}"
    elsif !self.title.blank? && self.organization.blank?
      "#{self.title}"
    else
      "#{self.title} at #{self.organization}"
    end
  end
  
  def is_scholar?
    self.role == 'scholar'
  end
  
  def is_member?
    self.role == 'member'
  end
  
end
