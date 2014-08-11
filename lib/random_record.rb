module RandomRecord
  extend ActiveSupport::Concern
  module ClassMethods
    def random
      raise 'Cannot get sample record because none exist.' if self.count == 0
      self.first(offset: rand(self.count))
    end
  end
end