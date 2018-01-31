
require "da_html_escape"
require "da_html_unescape"
require "uri"

module DA_URI

  extend self

  def empty?(n : Nil)
    true
  end # === def empty?

  def empty?(s : String)
    s.strip.empty?
  end # === def empty?

  # ===========================================================================
  # === URI ===================================================================
  # ===========================================================================

  VALID_FRAGMENT  = /^[a-zA-Z0-9\_\-]+$/
  BEGINNING_SLASH = /^\//
  CNTRL_CHARS     = /[[:cntrl:]]+/i
  WHITE_SPACE     = /[\s[:cntrl:]]+/i
  FIND_A_DOT      = /\./
  FIND_A_SLASH    = /\//
  PATH_HAS_A_HOST = /^[^\/]+\/?/

  def require_slash_for_relative_urls(u : URI)
    if !u.scheme && empty?(u.host) && (u.path.is_a?(String) && u.path !~ BEGINNING_SLASH)
      return nil
    end
    u
  end # === def slash_for_relative_urls

  def scheme(n : Nil)
    nil
  end # === def scheme

  def scheme(s : String)
    s = URI.unescape(s)
    return s if allowed_scheme?(s)

    new_s = URI.unescape(s.downcase.strip)
    return new_s if allowed_scheme?(new_s)
    nil
  end

  def scheme(u : URI)
    sch = u.scheme
    case sch
    when String
      u.scheme = (scheme(sch) || scheme(sch.downcase.strip))
    else
      u.scheme = scheme(sch)
    end

    u
  end

  def normalize(n : Nil)
    nil
  end # === def normalize

  def normalize(u : URI)
    return nil if empty?(u.host) && empty?(u.path) && empty?(u.fragment)

    fin = u.normalize.to_s.strip
    return nil if fin == ""

    fin
  end # === def normalize

  def escape_non_ascii(s : String)
    return nil unless s.valid_encoding?
    io = IO::Memory.new
    s.codepoints.each { |x|
      next if x <= 31 || x == 127
      io << x.chr if x < 127
      io << URI.escape(x.chr)
    }
    io.to_s
  end # === def escape_non_ascii

  def host(s : String)
    return nil if s =~ WHITE_SPACE
    return nil if s.empty?

    decoded = DA_HTML_UNESCAPE.unescape!( URI.unescape(s) )
    return nil if decoded != s

    s
  end # === def host

  def host(u : URI)
    s = u.host
    case s
    when String
      new_host = host(s)
      return nil unless new_host
      u.host = new_host
    end
    return u
  end # === def host

  def clean(raw : String)
    raw = DA_HTML_UNESCAPE.unescape!(raw.strip)
    return nil unless raw

    u = URI.parse(raw)

    origin_scheme = u.scheme

    u = default_host(u)
    {% for meth in "scheme uri_user uri_password uri_opaque uri_fragment host path".split  %}
      if u
        u = {{meth.id}}(u)
        return nil unless u
      end
    {% end %}

    # If the scheme disappeared, that means the entire
    # URL was invalid to begin with. Return nil to be
    # safe.
    return nil if origin_scheme && !u.scheme
    u = default_scheme(u)
    return nil unless u

    u = require_slash_for_relative_urls(u)
    return nil unless u

    u = normalize(u)
    return nil unless u

    DA_HTML_ESCAPE.escape(u)
  end # === def escape

  # ===========================================================================
  # private # ===================================================================
  # ===========================================================================

  def inspect_uri(n : Nil)
    puts n.inspect
  end

  def inspect_uri(s : String)
    inspect_uri(URI.parse(s))
  end # === def inspect_uri

  def inspect_uri(uri : URI)
    puts uri.to_s
    {% for id in ["scheme", "uri_opaque", "uri_user", "uri_password", "host", "path", "query", "uri_fragment"] %}
      spaces = " " * (15 - "{{id.id}}".size)
      puts "{{id.id}}:#{spaces}#{uri.{{id.id}}.inspect}"
    {% end %}
    puts uri.normalize.to_s
    puts ""
  end # === def inspect_uri

  def path(s : String)
    return nil if empty?(s)
    new_s = s.strip
    decoded = URI.unescape(new_s)
    return nil if decoded != new_s
    new_s
  end # === def path

  def path(n : Nil)
    nil
  end # === def path

  def path(u : URI)
    new_p = path(u.path)
    u.path = new_p
    u
  end # === def path

  def uri_user(u : URI)
    u.user = nil
    u
  end # === def uri_user

  def uri_password(u : URI)
    u.password = nil
    u
  end # === def uri_password

  # If .opaque is not nil, then that
  # means we are dealing with a missing double slash:
  # mailto:something
  # git:something
  # http:something
  # These are all invalid, including a valid mailto.
  # Those types of URIs should be handle by other shards/gems
  # for better error checking and security.
  def uri_opaque(u : URI)
    o = u.opaque
    return nil unless empty?(o)
    u
  end # === def uri_opaque

  def is_fragment_only?(u : URI)
    u.fragment && !u.host && !u.query && !u.path
  end

  def uri_fragment(s : String)
    s = s.strip
    return nil unless s =~ VALID_FRAGMENT
    s
  end # === def uri_fragment

  def uri_fragment(n : Nil)
    nil
  end

  def uri_fragment(u : URI)
    u.fragment = uri_fragment(u.fragment)
    u
  end # === def uri_fragment

  def allowed_scheme?(s : String)
    case s
    when "http", "https", "ftp", "sftp", "git", "ssh", "svn"
      return true
    end
    false
  end

  def default_host(u : URI)
    return u unless empty?(u.host)
    return u if empty?(u.path)
    path = u.path
    case path
    when String
      crumbs = path.split("/")
      return u if crumbs.empty?
      return u if empty?(crumbs.first) # /some/path
      new_host = crumbs.first
      crumbs[0] = ""
      u.host = new_host
      u.path = crumbs.join("/")
      u.path = nil if empty?(u.path)
    end
    u
  end # === def default_host

  def default_scheme(n : Nil)
    nil
  end # === def default_scheme

  def default_scheme(u : URI)
    if !u.scheme
      if !empty?(u.host)
        u.scheme = "http"
      end
    end
    u
  end # === def default_scheme

end # === module DA_URI
