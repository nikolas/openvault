## 
# Fixtures - Simple class for loading fixtures.
#
# Example 1 -- Just load the contents of a file.
# 
#   Fixtures.load('somefile')
#
#   # ... and get the content of the file like this...
#   Fixtures.use('somefile')
#
#   # ... or you can always get the original raw file content like this...
#   Fixtures.raw('somefile')
#
# Example 2 - Load a file and do something to it.
#
#   # Lets say I only want the first 50 characters of the file content...
#   Fixtures.load('somefile') { |f| f.raw.slice(0, 50) }
#
#   # ... and now I can use my 50 characters like this...
#   Fixtures.use('somefile')
#
#   # ... and the raw content is still available like this...
#   Fixtures.raw('somefile')
#
# Example 3 - Load a file and do multiple things to it.
#
#   # Lets say I want the the first 50 characters AND the last 50 characters of the file content...
#   Fixtures.load('somefile') do |f|
#     f.set(:first_50, f.raw.slice(0, 50))
#     f.set(:last_50, f.raw.slice(-50, 50))
#   end
#
#   # ... and we can get our uses like this...
#   Fixtures.use('somefile', :first_50)
#   Fixtures.use('somefile', :last_50)
#
#   # ... and the raw file content is then the default...
#   Fixtures.use('somefile')
#
#   # ... and still available like this too ...
#   Fixtures.raw('somefile')
#
#
# Example 4 - Do a repetitive thing to a bunch of files.
#
#   # Let's say I want to use Nokogiri to parse a bunch of xml file, and use the Nokogiri documents as my fixtures.
#   Fixtures.load(["xml_file1.xml", "xml_file2.xml", "xml_file3.xml"]) { |fixture| Nokogiri::XML(fixture.raw) }
#
#   # ... and we get the Nokogiri::XML::Document instances like this..
#   Fixtures.use("xml_file1.xml")
#   Fixtures.use("xml_file2.xml")
#   Fixtures.use("xml_file3.xml")
#
#   #... and we can use them like normal.
#   Fixtures.use("xml_file3.xml").xpath('//some_node@some_attribute')
#
#   # ... and we still have the raw file contents...
#   Fixtures.raw("xml_file2.xml")


class Fixtures
  include Singleton

  attr_accessor :loaded, :dir

  def initialize()
    @loaded = {}
    @dir = ''
  end

  class << self
    def load(filenames, &block)
      if filenames.respond_to? :each
        filenames.each do |filename|
          file_path = self.file_path(filename)
          self.instance.loaded[file_path] = Fixture.new(file_path, &block)
        end
      else
        # assume `filenames` arg is a single filename.
        file_path = self.file_path(filenames)
        self.instance.loaded[file_path] = Fixture.new(file_path, &block)
      end
    end

    def file_path(filename)
      # if there is a working directory, append a slash to it
      dir = self.pwd.nil? ? '' : self.pwd + "/"
      path = File.expand_path(dir + filename)
      raise "Fixture file not found for #{path}" unless File.exists? path
      path
    end

    def use(filename, key = nil)
      self.get(filename).use(key)
    end

    def raw(filename)
      self.get(filename).raw
    end

    def cwd(dir)
      self.instance.dir = dir
    end

    def pwd
      self.instance.dir
    end

    def get(filename)
      fixture = self.instance.loaded[self.file_path(filename)]
      raise "Fixture not found for #{self.file_path(filename)}. Be sure to set Fixture.cwd to the same value it was when the fixture was loaded." if fixture.nil?
      fixture      
    end

  end

  class Fixture

    attr_reader :raw

    def initialize(filename, &block)
      @raw = File.read(filename)
      @use = {}
      @default = nil
      
      if block_given?
        returned = yield(self)
        # if no explicit keys were set, then set default to value returned from the block
        @default = returned if @use.keys.count==0
      end

      # set default to raw file content if not already set 
      @default = @raw if @default.nil?

      self
    end

    def set(key, val=nil)
      @use[key] = val
    end

    def use(key=nil)
      key.nil?  ? @default : @use[key]
    end
  end
end