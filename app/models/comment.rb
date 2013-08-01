class Comment < ActiveRecord::Base
  attr_accessible :title, :comment, :commentable_id, :commentable_type, :metadata, :public, :user
  serialize :metadata

  include ActsAsCommentable::Comment
  #include BlacklightUserGeneratedContent::Comment

  belongs_to :commentable, :polymorphic => true

  default_scope :order => 'created_at ASC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  after_save do 
    self.commentable.save
  end

  def commentable
    SolrDocument.new(:id => self.commentable_id)
  end

end
