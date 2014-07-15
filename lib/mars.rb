module MARS
  module ID
    class << self
      # IDs in MARS are 15 alphanumeric characters prepended with a prefix.
      # NOTE: The prefixes have meaning, e.g. 'A_' indicates the ID is used in the 'assets' table,
      #   'P_' is used for IDs in the 'programs' table. There may be more, so there are currently
      #   no restrictions here on what prefix you specify.
      def generate(prefix='A_')
        alphanum = ('A'..'Z').to_a + (0..9).to_a
        prefix + (1..15).map { alphanum.sample }.join
      end
    end
  end
end