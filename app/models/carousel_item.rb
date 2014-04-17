class CarouselItem < ActiveRecord::Base
  attr_accessible :title, :body, :url, :image, :enabled, :position

  mount_uploader :image, CarouselImageUploader

  validates_presence_of :title, :on => :create, :message => "can't be blank"
  validates_presence_of :body, :on => :create, :message => "can't be blank"
  validates_presence_of :position, :on => :create, :message => "can't be blank"

  scope :carousel, order(position: 'ASC').limit(4)
end