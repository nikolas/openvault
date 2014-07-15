module Artesia
  module ID
    class << self
      # Artesia'S UOI_IDs are 40 lowercase hex digits.
      def generate
        (1..40).map { rand(15).to_s(16) }.join
      end
    end
  end
end