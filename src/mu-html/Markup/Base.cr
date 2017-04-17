
require "./Macro"

module Mu_Html

  module Base

    extend self

    def tag_name() : String
      self.to_s.downcase
    end

    def allowed_attrs(o : Hash, *keys)
      valid_keys = keys
      o.each_key do |k|
        raise Exception.new("Invalid key in #{tag_name}: #{k}") unless valid_keys.includes?(k)
      end
      o
    end # === def allowed_attrs

    def attr_tag_to_body_if_string(o : Hash) : Hash(String, JSON::Type)
      return o unless o.has_key?(tag_name)

      v = o[tag_name]
      raise Exception.new("Invalid attribute in #{tag_name}: tag") if o.has_key?("tag")

      o = case v
          when String
            raise Exception.new("#{tag_name} has body set twice.") if o.has_key?("body")
            o.delete(tag_name)
            o["body"] = v.strip
            o
          else
            o
          end
      o["tag"] = tag_name
      o
    end # === def attr_tag_to_body_if_string

    def attr_tag_delete_if_nil(o : Hash) : Hash(String, JSON::Type)
      return o unless o.has_key?(tag_name)

      v = o[tag_name]
      raise Exception.new("Invalid attribute in #{tag_name}: tag") if o.has_key?("tag")
      o = case v
          when Nil
            o.delete(tag_name)
            o
          else
            o
          end
      o["tag"] = tag_name
      o
    end # === def attr_tag_delete_if_nil

    def tag_attr_class(o : Hash) : Hash(String, JSON::Type)
      k = "class"
      v = o[k]
      case v
      when String
        v = v.strip
        if v =~ Markup::REGEX["class"]
          o["class"] = v
          return o
        end
      end
      raise Exception.new("Invalid value for #{tag_name} class attribute: #{v} (#{v.class})")
    end # === def tag_attr_class

    def tag_attr_childs(o : Hash) : Hash(String, JSON::Type)
      k = "childs"
      v = o[k]
      o["childs"] = case v
                    when Array
                      v
                    else
                      raise Exception.new("Invalid value for childs in #{tag_name}: #{v.class}")
                    end
      o
    end

    def standardize(origin : Hash(String, JSON::Type)) : Hash(String, JSON::Type)
      name = tag_name
      new_tag = tag_attr_tag(name, origin, name, origin[name])

      origin.each_key do |k|
        next if k == "tag"
        v = origin[k]

        {% for mod in Markup.constants.select { |x|
          y = Markup.constant(x)
          y.is_a?(TypeNode) && y.has_constant?(:ATTRS)
        } %}
          # Skipping methods like: P.tag_attr_p, DIV.tag_attr_div, etc.
          {% for meth in Markup.constant(mod).constant(:ATTRS).reject { |x| x == mod.downcase } %}
            if name == "{{mod.downcase}}" && k == {{meth}}
              new_tag = Markup::{{mod}}.tag_attr_{{meth.id}}(name, new_tag, k, v)
              next
            end
          {% end %} # === for meth
        {% end %} # == for mod

        raise Exception.new("Invalid key in #{name}: #{k}")
      end # each_key in origin

      new_tag
    end # === def standardize

    def allowed_attrs(o : Hash, k : String, allowed : Array )
      key_class = o[k]?.class
      return true if allowed.includes?(key_class)
      raise Exception.new("#{tag_name} can not have type: #{key_class}. Allowed: #{allowed}")
    end

    def allowed_attrs(o : Hash, allowed : Array)
      o.keys.each do |k|
        raise Exception.new("Invalid key in #{tag_name}: #{k}") unless allowed.includes?(k)
      end
      o
    end

    # Check for keys in Hash.
    #   required({}, ["key", "another key"])
    def required(o : Hash(String, JSON::Type), list : Array(String))
      list.each do |k|
        raise Exception.new("#{k} is required for #{tag_name}.") unless o.has_key?(k)
      end
      o
    end

    # Check for keys in Hash.
    #   required({}, "key")
    def required(o : Hash(String, JSON::Type), k : String)
      raise Exception.new("Key required for #{tag_name}: #{k}") unless o.has_key?(k)
      o
    end # === def require

    # Check for key and type of value:
    #   required({}, "key", [String, Int64, ...])
    def required(o : Hash(String, JSON::Type), k : String, list : Array)
      required o, k
      raise Exception.new("Invalid value for #{k} in #{tag_name}: #{o[k]?.class}") unless list.includes?(o[k]?.class)
    end

    # Check for key and type of value:
    #   required({}, "key", String, Int64, ...)
    def required(o : Hash(String, JSON::Type), k : String, *classes)
      raise Exception.new("Key required for #{tag_name}: #{k}") unless o.has_key?(k)
      raise Exception.new("Invalid value for #{k} in #{tag_name}: #{o[k]?.class}") unless classes.includes?(o[k]?.class)
      o
    end # === def required

    def move_attr_if_is_a(o : Hash(String, JSON::Type), k : String, new_key : String, target : Class) : Hash(String, JSON::Type)
      return o unless o.has_key?(k)
      v = o[k]

      case v
      when target
        if o.has_key?(new_key)
          raise Exception.new("#{new_key} attribute has been set twice in #{tag_name}: #{k}, #{new_key}")
        end
        o[new_key] = o[k]
        o.delete(k)
      end

      o
    end # === def move_if_is_a

  end # === module Base

end # === module Mu_Html
