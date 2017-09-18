

describe "Mu_Clean.uri" do

  it "hash with invalid chars" do
    Mu_Clean.uri("#my-link(here)").should(eq nil)
  end

  it "hash with valid chars" do
    Mu_Clean.uri("#my-link").should(eq "#my-link")
  end

  it "uri with data protocol" do
    Mu_Clean.uri("data://example.com").should(eq nil)
    Mu_Clean.uri("data:example.com").should(eq nil)
  end

  it "uri with javascript protocol" do
    Mu_Clean.uri("jaVasCrIpt:alert(0)").should(eq nil)
    Mu_Clean.uri("javascript://example.com").should(eq nil)
    Mu_Clean.uri("javascript:example.com").should(eq nil)
  end

  it "uri with unknown protocol" do
    Mu_Clean.uri("jscript://something.here").should(eq nil)
  end

  it "evil multi encoded uri" do
    Mu_Clean.uri("&#38;#38;#38;#106;&#38;#38;#38;#97;&#38;#38;#38;#118;&#38;#38;#38;#97;&#38;#38;#38;#115;&#38;#38;#38;#99;&#38;#38;#38;#114;&#38;#38;#38;#105;&#38;#38;#38;#112;&#38;#38;#38;#116;&#38;#38;#38;#58;&#38;#38;#38;#97;&#38;#38;#38;#108;&#38;#38;#38;#101;&#38;#38;#38;#114;&#38;#38;#38;#116;&#38;#38;#38;#40;&#38;#38;#38;#39;&#38;#38;#38;#49;&#38;#38;#38;#39;&#38;#38;#38;#41;").should(eq nil)
  end

  it "good multi-encoded uri" do
    Mu_Clean.uri("http&#38;#38;#38;#58;&#38;#38;#38;#x0002F;&#38;#38;#38;#x0002F;my.domain&#38;#38;#38;#x0002F;something").should(eq "http://my.domain/something")
  end

  it "lowercases host" do
    Mu_Clean.uri("HTtP://minun.com/").should(eq "http://minun.com/")
  end

  it "allowes relative addresses" do
    Mu_Clean.uri("/my/story/goes/here").should(eq "/my/story/goes/here")
  end

  it "single quotes are escaped" do
    Mu_Clean.uri("http://www.'.com/something").should(eq "http://www.&#39;.com/something")
  end

  it "double quotes are escaped" do
    Mu_Clean.uri("http://double.\".quotes/are/escaped").should(eq "http://double.&quot;.quotes/are/escaped")
  end

  it "rejects if cntrl chars" do
    Mu_Clean.uri("java\nscript:alert(\"8\")\n").should(eq nil)
    Mu_Clean.uri("ht\rtp://hanshoppe.com/path\n").should(eq nil)
    Mu_Clean.uri("java\nscript:alert(\"8\")\n").should(eq nil)
    Mu_Clean.uri("java\rscript:alert(\"9\")\n").should(eq nil)
  end

  it "rejects javascript" do
    Mu_Clean.uri("javascript:alert(\"1\")").should(eq nil)
    Mu_Clean.uri("javascript://alert(\"3\")").should(eq nil)
    Mu_Clean.uri("j a v a script:alert(\"5\")").should(eq nil)
    Mu_Clean.uri("javascript:alert(\"6\")").should(eq nil)
    Mu_Clean.uri("JavaScript:alert(\"7\")").should(eq nil)
  end

  it "rejects data urls" do
    Mu_Clean.uri("data:text/html;base64,PHNjcmlwdD5hbGVydCgnMScpPC9zY3JpcHQ+").should(eq nil)
    Mu_Clean.uri("data://text/html;base64,PHNjcmlwdD5hbGVydCgnMicpPC9zY3JpcHQ+").should(eq nil)
    Mu_Clean.uri("data:text/html;base64,PHNjcmlwdD5hbGVydCgnNScpPC9zY3JpcHQ+").should(eq nil)
    Mu_Clean.uri("da ta:text/html;base64,PHNjcmlwdD5hbGVydCgnNicpPC9zY3JpcHQ+").should(eq nil)
    Mu_Clean.uri("Data:text/html;base64,PHNjcmlwdD5hbGVydCgnNycpPC9zY3JpcHQ+").should(eq nil)
  end

  it "rejects if contains cntrl chars" do
    Mu_Clean.uri("http://\nwww.domain.domain\n").should(eq nil)
    Mu_Clean.uri("da\nta:text/html;base64,PHNjcmlwdD5hbGVydCgnOCcpPC9zY3JpcHQ+\n").should(eq nil)
    Mu_Clean.uri("da\rta:text/html;base64,PHNjcmlwdD5hbGVydCgnOScpPC9zY3JpcHQ+\n").should(eq nil)
    Mu_Clean.uri("da\nta:text/html;base64,PHNjcmlwdD5hbGVydCgnOCcpPC9zY3JpcHQ+\n").should(eq nil)
  end

  it "rejects missing path and fragment" do
    Mu_Clean.uri("http:foo.com").should(eq nil)
    Mu_Clean.uri("http://").should(eq nil)
    Mu_Clean.uri("http:").should(eq nil)
    Mu_Clean.uri("ftp:example.com").should(eq nil)
    Mu_Clean.uri("https:example.com").should(eq nil)
    Mu_Clean.uri("data:example.com").should(eq nil)
  end

  it "rejects paths with spaces" do
    Mu_Clean.uri("http:// foo.com/test").should(eq nil)
    Mu_Clean.uri("http:// foo.com").should(eq nil)
    Mu_Clean.uri("http:// foo.com/").should(eq nil)
    Mu_Clean.uri("http://foo.com /").should(eq nil)
    Mu_Clean.uri("http://foo .com/").should(eq nil)
  end

  it "rejects missing double slash" do
    Mu_Clean.uri("ftp:example.com").should(eq nil)
    Mu_Clean.uri("http:example.com").should(eq nil)
    Mu_Clean.uri("https:example.com").should(eq nil)
  end

  it "adds http if scheme is missing" do
    Mu_Clean.uri("www.my.dot.orh").should(eq "http://www.my.dot.orh")
    Mu_Clean.uri("dot.orh").should(eq "http://dot.orh")
    Mu_Clean.uri("dot.orh/my/path?a=b").should(eq "http://dot.orh/my/path?a&#61;b")
    Mu_Clean.uri("about/me").should(eq "http://about/me")
    Mu_Clean.uri("about/me.txt").should(eq "http://about/me.txt")
    Mu_Clean.uri("about.me/txt").should(eq "http://about.me/txt")
    Mu_Clean.uri("about/me/something").should(eq "http://about/me/something")
    Mu_Clean.uri("javascript//:alert(\"2\")").should(eq "http://javascript//:alert&#40;&quot;2&quot;&#41;")
    Mu_Clean.uri("javascript/:/alert(\"4\")").should(eq "http://javascript/:/alert&#40;&quot;4&quot;&#41;")
    Mu_Clean.uri("data//:text/html;base64,PHNjcmlwdD5hbGVydCgnMycpPC9zY3JpcHQ+").should(eq "http://data//:text/html;base64,PHNjcmlwdD5hbGVydCgnMycpPC9zY3JpcHQ&#43;")
    Mu_Clean.uri("data/:/text/html;base64,PHNjcmlwdD5hbGVydCgnNCcpPC9zY3JpcHQ+").should(eq "http://data/:/text/html;base64,PHNjcmlwdD5hbGVydCgnNCcpPC9zY3JpcHQ&#43;")
    Mu_Clean.uri("htt$p://example.com").should(eq "http://htt&#36;p://example.com")
    Mu_Clean.uri("j%avascript:alert(\"XSS\")").should(eq "http://j&#37;avascript:alert&#40;&quot;XSS&quot;&#41;")
    Mu_Clean.uri("htДtp://example.com").should(eq "http://ht&#37;D0&#37;94tp://example.com")
    Mu_Clean.uri("htДtp://example.com").should(eq "http://ht&#37;D0&#37;94tp://example.com")
    Mu_Clean.uri("htt$p://example.com").should(eq "http://htt&#36;p://example.com")
    Mu_Clean.uri("j%avascript:alert(\"XSS\")").should(eq "http://j&#37;avascript:alert&#40;&quot;XSS&quot;&#41;")
  end

  it "rejects evil strings Unicode encoded" do
    Mu_Clean.uri("&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#49;&#39;&#41;").should(eq nil)
    Mu_Clean.uri("&#x6A;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3A;&#x61;&#x6C;&#x65;&#x72;&#x74;&#x28;&#x27;&#x32;&#x27;&#x29;").should(eq nil)
  end

  it "rejects evil strings HEX Unicode encode" do
    Mu_Clean.uri("%6A%61%76%61%73%63%72%69%70%74%3A%61%6C%65%72%74%28%22%58%53%53%22%29").should(eq nil)
  end

  it "accepts valid URLs" do
    Mu_Clean.uri("http://example.com/http/foo").should(eq "http://example.com/http/foo")
    Mu_Clean.uri("http://www.example.com").should(eq "http://www.example.com")
    Mu_Clean.uri("https://www.example.com").should(eq "https://www.example.com")
    Mu_Clean.uri("ftp://www.example.com").should(eq "ftp://www.example.com")
  end

  it "dereferences HTML encoded chars in the scheme" do
    Mu_Clean.uri("h&#116;tp://example.com").should(eq "http://example.com")
    Mu_Clean.uri("h&#x74;tp://example.com").should(eq "http://example.com")
  end

  it "rejects URL-encoded schemes" do
    Mu_Clean.uri("h%74tp://example.com").should(eq nil)
  end

  it "rejects URL-encoded hosts" do
    Mu_Clean.uri("https://my.%74%74.com/").should(eq nil)
  end

  it "removes the username and password" do
    Mu_Clean.uri("http://someone%40gmail.com:password@example.com").should(eq "http://example.com")
  end

  it "URL-encodes code points outside ASCII" do
    Mu_Clean.uri("http://&#1044;").should(eq "http://&#37;D0&#37;94")
    Mu_Clean.uri("http://&#x0414;").should(eq "http://&#37;D0&#37;94")
    Mu_Clean.uri("http://Д").should(eq "http://&#37;D0&#37;94")
  end

  it "URL-encodes code points outside ASCII in path" do
    Mu_Clean.uri("http://a/Д/Д").should(eq "http://a/&#37;D0&#37;94/&#37;D0&#37;94")
    Mu_Clean.uri("http://a/a/b/cД/Д").should(eq "http://a/a/b/c&#37;D0&#37;94/&#37;D0&#37;94")
    Mu_Clean.uri("http://a/a/b/Д/d").should(eq "http://a/a/b/&#37;D0&#37;94/d")
  end

  it "rejects URLS with schemes only" do
    Mu_Clean.uri("http://").should(eq nil)
    Mu_Clean.uri("mailto://").should(eq nil)
    Mu_Clean.uri("sftp://").should(eq nil)
    Mu_Clean.uri("git://").should(eq nil)
  end

  it "rejects if double slash is missing" do
    Mu_Clean.uri("http:example.com").should(eq nil)
    Mu_Clean.uri("ftp:example.com").should(eq nil)
    Mu_Clean.uri("git:example.com").should(eq nil)
  end

  it "rejects mailto schemes" do
    Mu_Clean.uri("mailto:someone@example.com").should(eq nil)
  end

  it "dereferences numerics: hex_UTF8_char_ref" do
    Mu_Clean.uri("http://example.com/&#x6A;").should(eq "http://example.com/j")
  end

  it "dereferences numerics: long_form_decimal_UTF8_char_ref" do
    Mu_Clean.uri("http://example.com/&#0000106;").should(eq "http://example.com/j")
  end

  it "dereferences numerics: short_form_decimal_UTF8_char_ref" do
    Mu_Clean.uri("http://example.com/&#106;").should(eq "http://example.com/j")
  end

end # === describe
