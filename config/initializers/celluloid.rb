require 'celluloid/autostart'

# Add celluloid parallelization method `pmap` to Enumerable things.
module Enumerable
  def pmap(&block)
    futures = map { |elem| Celluloid::Future.new(elem, &block) }
    futures.map { |future| future.value }
  end
end