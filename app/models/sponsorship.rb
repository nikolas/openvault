class Sponsorship < ActiveRecord::Base
  belongs_to :artifact
  belongs_to :user

  attr_accessible :confirmed

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