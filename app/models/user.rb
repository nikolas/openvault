require 'random_record'

class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  include RandomRecord

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :postal_code, :country, :mla_updates,
                  :terms_and_conditions, :role, :username, :bio, :title, :organization, :avatar,
                  :org_ids

  has_many :owned_collections, as: :owner, class_name: CustomCollection

  has_many :custom_collection_collabs
  has_many :collab_collections, through: :custom_collection_collabs, source: :custom_collection

  has_many :artifact_logs
  has_many :sponsorships
  has_many :artifacts, :through => :sponsorships

  has_many :sponsored_artifacts, :through => :sponsorships, 
    :conditions => {'sponsorships.confirmed' => true},
    :source => :artifact
  
  has_many :potentially_sponsored_artifacts, :through => :sponsorships, 
    :conditions => {'sponsorships.confirmed' => false},
    :source => :artifact

  def collections
    (owned_collections + collab_collections).uniq
  end

  # This is a Rails thing that returns the value used in user routes, e.g. user_path, and edit_user_path
  def to_param
    username
  end

  has_many :affiliations
  has_many :orgs, through: :affiliations

  validates_presence_of :first_name, :message => "can't be blank"
  validates_presence_of :last_name, :message => "can't be blank"
  validates_presence_of :country, :message => "can't be blank"
  validates_uniqueness_of :email, :message => "must be unique"
  validates_presence_of :role, :message => "can't be blank"
  validates_inclusion_of :role, :in => %w( member scholar ), :on => :create, :message => "role %s is not included in the list"
  validates :bio, :length => { :maximum => 5000 }
  validates_presence_of :terms_and_conditions, :message => "must be agreed to"

  scope :scholars, where(:role => 'scholar')

  before_save :is_new
  before_save :create_slug

  mount_uploader :avatar, AvatarUploader

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def url
    if self.role == 'scholar'
      "/scholar/#{self.username}"
    else
      "/user/#{self.username}"
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def last_name_first
    "#{last_name}, #{first_name}"
  end

  def requested_artifact?(artifact)
    !!artifacts.find_by_id(artifact.id)
  end

  def collection_id
    return if owned_collections.empty?
    self.owned_collections.first.id unless self.role != 'scholar' and self.owned_collections.count == 0
  end

  def has_item_in_collection?(id)
    return if owned_collections.empty?
    items = self.owned_collections.first.custom_collection_items.map{|c| c.openvault_asset_pid}
    items.include?(id)
  end

  def is_scholar?
    self.role == 'scholar'
  end

  def is_member?
    self.role == 'member'
  end

  def primary_organization
    affiliations.each do |affiliation| 
      if affiliation.org.nil?
        return nil
      elsif affiliation.primary 
        return affiliation.org.name
      end
    end
  end

  def primary_title
    affiliations.each do |affiliation|
      if affiliation.primary
        return affiliation.title
      end
    end
  end

  private

  def is_new
    @was_a_new_record = new_record?
    return true
  end

  def create_slug
    if @was_a_new_record || self.username.blank?
      ret = self.full_name.strip.downcase
      #repeated from collections controller for special character cases
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

      #get all current usernames
      existing_usernames = User.all.map(&:username).flatten.uniq.to_set # TODO: Very very memory intensive and doesn't scale well!

      #make user names unique
      (0..1000).each do |i|
        if i == 0
          current_username = ret
        else
          current_username = "#{ret}-#{i}"
        end
        #keep going untill a username-N is available
        next if existing_usernames.include? current_username
          write_attribute(:username, current_username)
        break
      end
    end
  end


end
