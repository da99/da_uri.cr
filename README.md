clean.cr
==========

A Crystal shard full of functions to clean HTML-releated content.

You don't want to use this shard because it's too specific for my needs.
it's very strict and only allows `http`, `https`, `ftp`, `sftp`.
no `mailto` or other schemes. so it's basically useless for most people
unless they share my views on paranoid security.

However, if you know of another uri/url/HTML sanitization shard
please let me know in the "issues" section
so i can tell others about it.

Usage
=============

```crystal
  require "clean"

  Mu_Clean.attr("input", {"type"=>"hidden", "value"=>"my val"})
  Mu_Clean.attr("meta", {"name"=>"keywords", "content"=>" <my content> "})
  Mu_Clean.escape_html("my <html>")
  Mu_Clean.uri("http://my.uri")
```

Specs
==================

Specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
