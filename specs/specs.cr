
require "../src/da_uri"

require "spec"

describe "DA_URI.clean" do

  it "hash with invalid chars" do
    DA_URI.clean("#my-link(here)").should(eq nil)
  end

  it "hash with valid chars" do
    DA_URI.clean("#my-link").should(eq "#my-link")
  end

  it "returns nil if the uri uses the \"data:\" protocol" do
    DA_URI.clean("data://example.com").should(eq nil)
    DA_URI.clean("data:example.com").should(eq nil)
  end

  it "uri with javascript protocol" do
    DA_URI.clean("jaVasCrIpt:alert(0)").should(eq nil)
    DA_URI.clean("javascript://example.com").should(eq nil)
    DA_URI.clean("javascript:example.com").should(eq nil)
  end

  it "uri with unknown protocol" do
    DA_URI.clean("jscript://something.here").should(eq nil)
  end

  it "evil multi encoded uri" do
    DA_URI.clean("&#38;#38;#38;#106;&#38;#38;#38;#97;&#38;#38;#38;#118;&#38;#38;#38;#97;&#38;#38;#38;#115;&#38;#38;#38;#99;&#38;#38;#38;#114;&#38;#38;#38;#105;&#38;#38;#38;#112;&#38;#38;#38;#116;&#38;#38;#38;#58;&#38;#38;#38;#97;&#38;#38;#38;#108;&#38;#38;#38;#101;&#38;#38;#38;#114;&#38;#38;#38;#116;&#38;#38;#38;#40;&#38;#38;#38;#39;&#38;#38;#38;#49;&#38;#38;#38;#39;&#38;#38;#38;#41;").should(eq nil)
  end

  it "good multi-encoded uri" do
    DA_URI.clean("http&#38;#38;#38;#58;&#38;#38;#38;#x0002F;&#38;#38;#38;#x0002F;my.domain&#38;#38;#38;#x0002F;something").should(eq "http://my.domain/something")
  end

  it "lowercases host" do
    DA_URI.clean("HTtP://minun.com/").should(eq "http://minun.com/")
  end

  it "allowes relative addresses" do
    DA_URI.clean("/my/story/goes/here").should(eq "/my/story/goes/here")
  end

  it "single quotes are escaped" do
    DA_URI.clean("http://www.'.com/something").should(eq "http://www.&#39;.com/something")
  end

  it "double quotes are escaped" do
    DA_URI.clean("http://double.\".quotes/are/escaped").should(eq "http://double.&quot;.quotes/are/escaped")
  end

  it "rejects if cntrl chars" do
    DA_URI.clean("java\nscript:alert(\"8\")\n").should(eq nil)
    DA_URI.clean("ht\rtp://hanshoppe.com/path\n").should(eq nil)
    DA_URI.clean("java\nscript:alert(\"8\")\n").should(eq nil)
    DA_URI.clean("java\rscript:alert(\"9\")\n").should(eq nil)
  end

  it "rejects javascript" do
    DA_URI.clean("javascript:alert(\"1\")").should(eq nil)
    DA_URI.clean("javascript://alert(\"3\")").should(eq nil)
    DA_URI.clean("j a v a script:alert(\"5\")").should(eq nil)
    DA_URI.clean("javascript:alert(\"6\")").should(eq nil)
    DA_URI.clean("JavaScript:alert(\"7\")").should(eq nil)
  end

  it "rejects data urls" do
    DA_URI.clean("data:text/html;base64,PHNjcmlwdD5hbGVydCgnMScpPC9zY3JpcHQ+").should(eq nil)
    DA_URI.clean("data://text/html;base64,PHNjcmlwdD5hbGVydCgnMicpPC9zY3JpcHQ+").should(eq nil)
    DA_URI.clean("data:text/html;base64,PHNjcmlwdD5hbGVydCgnNScpPC9zY3JpcHQ+").should(eq nil)
    DA_URI.clean("da ta:text/html;base64,PHNjcmlwdD5hbGVydCgnNicpPC9zY3JpcHQ+").should(eq nil)
    DA_URI.clean("Data:text/html;base64,PHNjcmlwdD5hbGVydCgnNycpPC9zY3JpcHQ+").should(eq nil)
  end

  it "rejects if contains cntrl chars" do
    DA_URI.clean("http://\nwww.domain.domain\n").should(eq nil)
    DA_URI.clean("da\nta:text/html;base64,PHNjcmlwdD5hbGVydCgnOCcpPC9zY3JpcHQ+\n").should(eq nil)
    DA_URI.clean("da\rta:text/html;base64,PHNjcmlwdD5hbGVydCgnOScpPC9zY3JpcHQ+\n").should(eq nil)
    DA_URI.clean("da\nta:text/html;base64,PHNjcmlwdD5hbGVydCgnOCcpPC9zY3JpcHQ+\n").should(eq nil)
  end

  it "rejects missing path and fragment" do
    DA_URI.clean("http:foo.com").should(eq nil)
    DA_URI.clean("http://").should(eq nil)
    DA_URI.clean("http:").should(eq nil)
    DA_URI.clean("ftp:example.com").should(eq nil)
    DA_URI.clean("https:example.com").should(eq nil)
    DA_URI.clean("data:example.com").should(eq nil)
  end

  it "rejects paths with spaces" do
    DA_URI.clean("http:// foo.com/test").should(eq nil)
    DA_URI.clean("http:// foo.com").should(eq nil)
    DA_URI.clean("http:// foo.com/").should(eq nil)
    DA_URI.clean("http://foo.com /").should(eq nil)
    DA_URI.clean("http://foo .com/").should(eq nil)
  end

  it "rejects missing double slash" do
    DA_URI.clean("ftp:example.com").should(eq nil)
    DA_URI.clean("http:example.com").should(eq nil)
    DA_URI.clean("https:example.com").should(eq nil)
  end

  it "adds http if scheme is missing" do
    DA_URI.clean("www.my.dot.orh").should(eq "http://www.my.dot.orh")
    DA_URI.clean("dot.orh").should(eq "http://dot.orh")
    DA_URI.clean("dot.orh/my/path?a=b").should(eq "http://dot.orh/my/path?a&#61;b")
    DA_URI.clean("about/me").should(eq "http://about/me")
    DA_URI.clean("about/me.txt").should(eq "http://about/me.txt")
    DA_URI.clean("about.me/txt").should(eq "http://about.me/txt")
    DA_URI.clean("about/me/something").should(eq "http://about/me/something")
    DA_URI.clean("javascript//:alert(\"2\")").should(eq "http://javascript//:alert&#40;&quot;2&quot;&#41;")
    DA_URI.clean("javascript/:/alert(\"4\")").should(eq "http://javascript/:/alert&#40;&quot;4&quot;&#41;")
    DA_URI.clean("data//:text/html;base64,PHNjcmlwdD5hbGVydCgnMycpPC9zY3JpcHQ+").should(eq "http://data//:text/html;base64,PHNjcmlwdD5hbGVydCgnMycpPC9zY3JpcHQ&#43;")
    DA_URI.clean("data/:/text/html;base64,PHNjcmlwdD5hbGVydCgnNCcpPC9zY3JpcHQ+").should(eq "http://data/:/text/html;base64,PHNjcmlwdD5hbGVydCgnNCcpPC9zY3JpcHQ&#43;")
    DA_URI.clean("htt$p://example.com").should(eq "http://htt&#36;p://example.com")
    DA_URI.clean("j%avascript:alert(\"XSS\")").should(eq "http://j&#37;avascript:alert&#40;&quot;XSS&quot;&#41;")
    DA_URI.clean("htДtp://example.com").should(eq "http://ht&#37;D0&#37;94tp://example.com")
    DA_URI.clean("htДtp://example.com").should(eq "http://ht&#37;D0&#37;94tp://example.com")
    DA_URI.clean("htt$p://example.com").should(eq "http://htt&#36;p://example.com")
    DA_URI.clean("j%avascript:alert(\"XSS\")").should(eq "http://j&#37;avascript:alert&#40;&quot;XSS&quot;&#41;")
  end

  it "rejects evil strings Unicode encoded" do
    DA_URI.clean("&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#49;&#39;&#41;").should(eq nil)
    DA_URI.clean("&#x6A;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3A;&#x61;&#x6C;&#x65;&#x72;&#x74;&#x28;&#x27;&#x32;&#x27;&#x29;").should(eq nil)
  end

  it "rejects evil strings HEX Unicode encode" do
    DA_URI.clean("%6A%61%76%61%73%63%72%69%70%74%3A%61%6C%65%72%74%28%22%58%53%53%22%29").should(eq nil)
  end

  it "accepts valid URLs" do
    DA_URI.clean("http://example.com/http/foo").should(eq "http://example.com/http/foo")
    DA_URI.clean("http://www.example.com").should(eq "http://www.example.com")
    DA_URI.clean("https://www.example.com").should(eq "https://www.example.com")
    DA_URI.clean("ftp://www.example.com").should(eq "ftp://www.example.com")
  end

  it "dereferences HTML encoded chars in the scheme" do
    DA_URI.clean("h&#116;tp://example.com").should(eq "http://example.com")
    DA_URI.clean("h&#x74;tp://example.com").should(eq "http://example.com")
  end

  it "rejects URL-encoded schemes" do
    DA_URI.clean("h%74tp://example.com").should(eq nil)
  end

  it "rejects URL-encoded hosts" do
    DA_URI.clean("https://my.%74%74.com/").should(eq nil)
  end

  it "removes the username and password" do
    DA_URI.clean("http://someone%40gmail.com:password@example.com").should(eq "http://example.com")
  end

  it "URL-encodes code points outside ASCII" do
    DA_URI.clean("http://&#1044;").should(eq "http://&#37;D0&#37;94")
    DA_URI.clean("http://&#x0414;").should(eq "http://&#37;D0&#37;94")
    DA_URI.clean("http://Д").should(eq "http://&#37;D0&#37;94")
  end

  it "URL-encodes code points outside ASCII in path" do
    DA_URI.clean("http://a/Д/Д").should(eq "http://a/&#37;D0&#37;94/&#37;D0&#37;94")
    DA_URI.clean("http://a/a/b/cД/Д").should(eq "http://a/a/b/c&#37;D0&#37;94/&#37;D0&#37;94")
    DA_URI.clean("http://a/a/b/Д/d").should(eq "http://a/a/b/&#37;D0&#37;94/d")
  end

  it "rejects URLS with schemes only" do
    DA_URI.clean("http://").should(eq nil)
    DA_URI.clean("mailto://").should(eq nil)
    DA_URI.clean("sftp://").should(eq nil)
    DA_URI.clean("git://").should(eq nil)
  end

  it "rejects if double slash is missing" do
    DA_URI.clean("http:example.com").should(eq nil)
    DA_URI.clean("ftp:example.com").should(eq nil)
    DA_URI.clean("git:example.com").should(eq nil)
  end

  it "rejects mailto schemes" do
    DA_URI.clean("mailto:someone@example.com").should(eq nil)
  end

  it "dereferences numerics: hex_UTF8_char_ref" do
    DA_URI.clean("http://example.com/&#x6A;").should(eq "http://example.com/j")
  end

  it "dereferences numerics: long_form_decimal_UTF8_char_ref" do
    DA_URI.clean("http://example.com/&#0000106;").should(eq "http://example.com/j")
  end

  it "dereferences numerics: short_form_decimal_UTF8_char_ref" do
    DA_URI.clean("http://example.com/&#106;").should(eq "http://example.com/j")
  end

end # === describe



