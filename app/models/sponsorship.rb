class Sponsorship < ActiveRecord::Base
  belongs_to :artifact
  belongs_to :user

  attr_accessible :confirmed

  validates_presence_of :user_id
  validates_presence_of :artifact_id

  def status
    confirmed? ? 'Confirmed/Sponsor' : 'Requested'
  end

  def confirm!
    update_attributes(:confirmed => true)
  end

  def unconfirm!
    update_attributes(:confirmed => false)
  end
end