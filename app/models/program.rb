class Program < OpenvaultAsset
  # attr_accessible :title, :body
  belongs_to :series, :property => :is_part_of
  has_many :videos, :property => :is_part_of
  has_many :audios, :property => :is_part_of
  
  
  # metadata for Program
  #     - episodic info
  #     - segment info (e.g. "part 1 of 3")
  #     - dates (e.g. when it aired)
  #     - producer info
  #     - people involved (e.g. interviewees, talent, etc)
  #     - copyright info
end
