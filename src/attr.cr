
module Mu_Clean
  def attr(*args)
    Mu_WWW_Attr.clean(*args)
  end # === def attr
end # === module Mu_Clean

module Mu_WWW_Attr

  extend self

  def self.invalid(tag_name, name, val)
    raise Exception.new("Invalid attribute: #{tag_name.inspect}.#{name.inspect} = #{val.inspect}")
  end # === def invalid_attr

  def clean(val : Nil)
    ""
  end # === def clean

  def clean(val : String)
    Mu_Clean.escape_html val
  end # === def clean

  def clean(val : Int32 | Int64)
    val.to_s
  end # === def clean

  def clean(tag, attrs : Hash(String, String))
    attrs.keys.each do |name|
      new_attrs = tag_attr(tag, name, attrs[name], attrs)

      if new_attrs.is_a?(Hash)
        attrs = new_attrs
        next
      end

      return nil
    end # each key

    attrs.keys.each do |name|
      attrs[name] = clean(attrs[name])
    end

    attrs
  end # === def clean

  def valid_key?( val : String )
    val =~ /^[a-z0-9\_\-]+$/i
  end # === def valid_key?

  def tag_attr(tag : String, name : String, val : String, attrs : Hash)
    case

    when tag == "html" && name == "lang"
      val =~ /^[a-z0-9\-\_]+$/ && attrs

    when name == "id"
      val =~ /^[a-z0-9\_\-]+$/i && attrs

    when tag == "input" && name == "name"
      val =~ /^[a-zA-Z0-9\_\-]+$/ && attrs

    when tag == "input" && name == "value"
      val =~ /^[a-zA-Z0-9\_\ \-\.]+$/ && attrs

    when tag == "input" && name == "type" && val == "hidden"
      attrs

    when tag == "script" && name == "defer"
      (val =~ /true|false/i) && attrs

    when tag == "script" && name == "src"
      new_val = Mu_Clean_URI.clean(val)
      if new_val.is_a?(String)
        attrs[name] = new_val
        attrs
      else
        nil
      end

    when tag == "script" && name == "async"
      (val =~ /true|false/i) && attrs

    when tag == "script" && name == "src"
      val =~ /^[a-z0-9\_\.\/]+$/i && attrs

    when name == "class"
      val.is_a?(String) && val =~ /^[a-zA-Z0-9\_\ ]+$/ && attrs

    when tag == "link" && name == "href"
      if val !~ /^\/[a-zA-Z\.0-9\-\_\/]+$/
        return nil
      end
      new_val = Mu_Clean_URI.clean(val)
      if new_val.is_a?(String)
        attrs[name] = new_val
        attrs
      else
        nil
      end

    when tag == "link" && name == "rel"
      val =~ /^[a-zA-Z0-9\ ]+$/ && attrs

    when tag == "link" && name == "title"
      val =~ /^[a-zA-Z0-9\ \_\-\.]+$/ && attrs

    when tag == "link" && name == "type" && val =~ /^text\/css;?$/i
      attrs

    when tag == "link" && name == "media" && val =~ /^[\(\)\-\:\ a-zA-Z0-9]+$/
      attrs

    when tag == "a" && name == "href"
      new_val = Mu_Clean_URI.clean(val)
      if new_val.is_a?(String)
        attrs[name] = new_val
        attrs
      else
        nil
      end

    when tag == "form" && name == "action"
      if val !~ /^\/[a-zA-Z0-9\.\_\-\/]+$/ 
        return nil
      end
      new_val = Mu_Clean_URI.clean(val)
      if new_val.is_a?(String)
        attrs[name] = new_val
        attrs
      else
        nil
      end

    when tag == "meta" && name == "charset"
      val =~ /^[a-z\-0-9]+$/ && attrs

      # For security reasons, "refresh" is left out.
    when tag == "meta" && name == "http-equiv" && val =~ /^content-security-policy$/i
      content = attrs["content"]?
      content.is_a?(String) && content =~ /^[a-zA-Z\;\:\/\ \*\'\-\_\.]+$/ && attrs

    when tag == "meta" && name == "http-equiv" && val =~ /^Content-Type$/i
      content = attrs["content"]?
      content.is_a?(String) && content =~ /^[a-zA-Z\;\-\=\/\ ]+$/ && attrs

    when tag == "meta" && name == "name" && val == "keywords"
      content = attrs["content"]?
      content.is_a?(String) && content =~ /^[a-zA-Z0-9\,\_\-\ \,\>\<\/]+$/ && attrs

    when tag == "meta" && name == "content"
      attrs

    else
      nil

    end # == case
  end # === def tag_attr

end # === module Mu_WWW_Attr
