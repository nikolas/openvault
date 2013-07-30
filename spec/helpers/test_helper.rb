class WarningSuppressor
  class << self
    def write(message)
      puts(message) unless message =~ /QFont::setPixelSize: Pixel size <= 0/
      0
    end
  end
end