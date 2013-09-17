class VideoProgram < Program
  # attr_accessible :title, :body
  has_many :videos, :property => :is_part_of
  has_many :additional_videos, :property => :is_part_of, :class => Video
end
