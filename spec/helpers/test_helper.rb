class WarningSuppressor
  class << self
    def write(message)
      puts(message) unless message =~ /QFont::setPixelSize: Pixel size <= 0/ || message =~ /CoreText performance note: Client called CTFontCreateWithName() using name "Arial" and got font with PostScript name "ArialMT". For best performance, only use PostScript names when calling this API./
      0
    end
  end
end