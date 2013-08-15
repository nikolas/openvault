
# Class with array-like access for loading fixtures.
class Fixtures

  @@loaded = {}
  @@base_dir = ''

  # Shortcut array-like access to @loaded hash.
  def self.[](key)
    @@loaded[key]
  end

  # Shortcut array-like access to @loaded hash.
  def self.[]=(key, val)
    @@loaded[key] = val
  end

  def self.base_dir
    @@base_dir
  end

  def self.base_dir= val
    @@base_dir = val
  end
end