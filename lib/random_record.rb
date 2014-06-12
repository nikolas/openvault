module RandomRecord
  extend ActiveSupport::Concern
  module ClassMethods
    def random
      raise 'Cannot get sample record because none exist.' unless self.count
      self.first(offset: rand(self.count))
    end
  end
end