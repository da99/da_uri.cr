

Usage
=====

```crystal

  require "mu-clean"

  Mu_Clean.attr("input", {"type"=>"hidden", "value"=>"my val"})
  Mu_Clean.attr("meta", {"name"=>"keywords", "content"=>" <my content> "})
  Mu_Clean.escape("my <html>")
  Mu_Clean.uri("http://my.uri")

```

Void Linux
==========

Install libxml2-devel


Mu\_Clean.uri
================

I use this shard to sanitize uri/urls for `src` and `href` html attributes.

however, if you know of another uri/url sanitization shard to be used for
`src` and `href` attributes, please let me know in the "issues" section
so i can tell others about it.

you don't want to use this shard because it's too specific for my needs.
it's very strict and only allows `http`, `https`, `ftp`, `sftp`.
no `mailto` or other schemes. so it's basically useless for most people
unless they share my views on paranoid security.


specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec
