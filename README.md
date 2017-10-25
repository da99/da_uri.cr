da\_uri.cr
==========

A Crystal shard to clean up URIs.

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
  require "da_uri"

  DA_URI.clean("http://my.uri")
```

Specs
==================

Specs for this shard was inspired by:
  * https://github.com/jarrett/sanitize-url/tree/master/spec

TODO:
====

* koa-uri-sanitize: https://github.com/tilap/koa-sanitize-uri
