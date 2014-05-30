class WarningSuppressor

  SUPPRESS = [
    'QFont::setPixelSize: Pixel size <= 0',
    'CoreText performance note:',
    'FB.getLoginStatus() called before calling FB.init()',
    'Invalid App Id: Must be a number or numeric string representing the application id.'
  ]

  class << self
    def write(message)
      if suppress?(message) then 0 else puts(message);1;end
    end

    def suppress?(message)
      SUPPRESS.reduce { |r, matcher| r || message =~ /#{matcher}/ }
    end
  end
end
