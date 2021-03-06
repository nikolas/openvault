class Artifact < ActiveRecord::Base
  # Disable STI
  self.inheritance_column = :_type_disabled

  has_many :artifact_logs
  has_many :sponsorships
  has_many :users, :through => :sponsorships

  has_many :sponsors, :through => :sponsorships, 
    :conditions => {'sponsorships.confirmed' => true},
    :source => :user
  has_many :potential_sponsors, :through => :sponsorships, 
    :conditions => {'sponsorships.confirmed' => false},
    :source => :user

  validates_presence_of :pid

  search_methods :sponsorship_user_ids_eq

  scope :sponsorship_user_ids_eq, lambda { |user_id|
    Artifact.joins(:sponsorships).where("user_id = ?", user_id)
  }
  
  attr_accessible :pid

  state_machine :initial => :initiated do
    event :request do;    transition :initiated => :requested; end
    event :withdraw do;   transition [:requested, :digitizing] => :initiated; end
    event :digitize do;   transition :requested => :digitizing; end
    event :block do;       transition :requested => :blocked; end
    event :publish do;  transition :digitizing => :published; end

    before_transition any => any do |artifact, transition|
      raise ArgumentError, "Specify a user" unless transition.args.first
    end

    after_transition any => any do |artifact, transition|
      user = transition.args.first
      ArtifactLog.record(user, artifact, {
        event: transition.event,
        from: transition.from,
        to: transition.to
      })
    end

    after_transition :on => :withdraw do |artifact, transition|
      user = transition.args.first
      artifact.withdraw_user(user)
      Rails.logger.info('WITHDRAWN')
      AdminMailer.request_withdrawn_email(user, artifact).deliver
      UserMailer.request_withdrawn_email(user, artifact).deliver
    end

    after_transition :on => :request do |artifact, transition|
      user = transition.args.first
      artifact.potential_sponsors << user
      Rails.logger.info('REQUESTED')
      UserMailer.digitization_requested_email(user, artifact).deliver
      AdminMailer.request_notification_email(user, artifact).deliver
    end

    after_transition :on => :digitize do |artifact, transition| 
      user = transition.args.first
      Rails.logger.info('DIGITIZING')
      artifact.users.each do |user| 
        UserMailer.digitization_approval_email(user, artifact).deliver
      end
    end

    after_transition :on => :block do |artifact, transition| 
      user = transition.args.first
      Rails.logger.info('BLOCKED')
      artifact.users.each do |user| 
        UserMailer.digitization_blocked_email(user, artifact).deliver
      end
    end

    after_transition :on => :publish do |artifact, transition| 
      user = transition.args.first
      Rails.logger.info('PUBLISHED')
      artifact.users.each do |user|
        UserMailer.digitization_published_email(user, artifact).deliver
      end
    end
  end

  def to_s
    "ID#{id}: SOLR_ID"
  end

  def request_digitization(user)
    if state == 'initiated'
      request!(user)
    else
      potential_sponsors << user
      ArtifactLog.record(user, self, {
        event: 'request',
        from: 'requested',
        to: 'requested',
        description: 'User requested digitization on previously requested artifact'
      })
    end
  end

  def withdraw_request(user)
    if sponsorships.size == 1
      withdraw!(user)
    else
      withdraw_user(user)
      ArtifactLog.record(user, self, {
        event: 'withdraw',
        from: 'requested',
        to: 'requested',
        description: 'User withdrew sponsorship (other sponsors still available)'
      })
    end
  end

  def withdraw_user(user, options={})
    sponsorships.where(:user_id => user).first.delete
    user.artifacts.reload
  end

  def approve_digitization(user)
    digitize!(user)
    ArtifactLog.record(user, self, {
      event: 'digitize',
      from: 'requested',
      to: 'digitizing',
      description: 'Digitization approved and in process'
    })
  end

  def block_digitization(user)
    block!(user)
    ArtifactLog.record(user, self, {
      event: 'block',
      from: 'requested',
      to: 'blocked',
      description: 'Digitization has been blocked'
    })
  end

  def publish_digitization(user)
    publish!(user)
    ArtifactLog.record(user, self, {
      event: 'publish',
      from: 'requested',
      to: 'published',
      description: 'Digitization has been published and is available'
    })
  end

  def ov_asset
    @ov_asset ||= begin
      OpenvaultAsset::find(pid, cast: true)
    rescue ActiveFedora::ObjectNotFoundError => e
      # Do not raise ActiveFedora::ObjectNotFoundError, instead, set @ov_asset to nil.
      nil
    end
  end

  # Returns the first found solr result found for @pid, or if nothing found, an empty hash
  def solr_doc
    @solr_doc ||= Blacklight.solr.select(params: {q: "id:#{pid}"})['response']['docs'].first || {}
  end

  def asset_path
    "/catalog/#{solr_doc['slug'] || pid}"
  end
 
  def title
    @title ||= begin
      ov_asset.title
    rescue NoMethodError => e
      "#{pid} (deleted)"
    end
  end
  
  def digitizing?
    state == 'digitizing'
  end
end
