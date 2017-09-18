clean.cr
==========

Functions to clean HTML-releated content.
Written as a Crystal shard.

Usage
=============

```crystal
  require "clean"

  Mu_Clean.attr("input", {"type"=>"hidden", "value"=>"my val"})
  Mu_Clean.attr("meta", {"name"=>"keywords", "content"=>" <my content> "})
  Mu_Clean.browser_string("my <html>")
  Mu_Clean.uri("http://my.uri")
```

Mu\_Clean.uri
==================

I use this shard to sanitize uri/urls for `src` and `href` html attributes.

However, if you know of another uri/url sanitization shard to be used for
`src` and `href` attributes, please let me know in the "issues" section
so i can tell others about it.

You don't want to use this shard because it's too specific for my needs.
it's very strict and only allows `http`, `https`, `ftp`, `sftp`.
no `mailto` or other schemes. so it's basically useless for most people
unless they share my views on paranoid security.


Specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
