module SafeTruncateHelper
  def safe_truncate string, *args
    # docs claim truncate is html_safe, 
    #   http://api.rubyonrails.org/classes/ActionView/Helpers/TextHelper.html#method-i-truncate:
    #   "The result is marked as HTML-safe"
    # but that doesn't seem to actually be the case:
    #  > 'foo'.html_safe.class
    #  => ActiveSupport::SafeBuffer
    #  > truncate('foo').class
    #  => String
    options = args.extract_options!
    options[:length] ||= 250
    options[:separator] ||= ' '
    raw(truncate(strip_tags(string), options))
  end
end