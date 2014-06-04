module HtmlStyleHelper
  def hash_to_style(hash)
    raise "First argument must be a hash. #{hash.class} was given." unless hash.respond_to? :each
    style = []
    hash.each do |k,v|
      style << "#{k}:#{v}"
    end
    style.join('; ')
  end

  def style_to_hash(style)
    hash = HashWithIndifferentAccess.new
    style.split(';').each do |css_property_and_val|
      css_property, css_val = css_property_and_val.strip.split(':')
      hash[css_property] = css_val
    end
    hash
  end
end