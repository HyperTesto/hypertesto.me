---
title: "Newline-delimited JSON: an unstandardized standard"
date: 2023-06-29T22:26:49.020Z
draft: true
description: ""
tags:
  - json
  - formats
---
I admit that I had never heard of this data format before this spring.

I was getting some errors following the official documentation of an open source library for creating ASR systems[^0].  
Nothing was making sense until I noticed I wasn't working with a JSON array of objects, but rather JSON objects separated by a newline. _Eureka_!

In its simplicity is truly an ingenious solution to the problem of deserializing large JSON files: you read it line by line which is simple, flexible, easy to understand and very effective!

## ndjson-lines-seq what?

This format is very simple, but it's standardization is not; in fact there are 2 commonly accepted (not officially recognized but identical in practice) specs:

* Newline Delimited JSON (ndjson)
* JSON Lines (jsonl[^1])

The only difference i could find i those two specs it's ndjson ays: 

> All serialized data MUST use the UTF8 encoding.

While jsonl says:

> JSON allows encoding Unicode strings with only ASCII escape sequences, however those escapes will be hard to read when viewed in a text editor. The author of the JSON Lines file may choose to escape characters to work with plain ASCII files.

In practice they are both identical, and the original authors of ndjson stated he's not against deprecating it in favour of jsonl[^2].

There is a third contender which was RFC'd in 2014: [RFC 7464](https://datatracker.ietf.org/doc/html/rfc7464) which has some more rule about encoding, delimiting and invalid/incomplete JSON texts.  

As far as i understand, this RFC is still a _proposed standard_ and jsonl and ndjson are more widespread even though they have never been submitted to RFC[^3].

## OK, this format is extremely simple, so why the formalism matters?

If we talk about the file format itself, there aren't many issues not having a standard, as long as both parties involved  know how to serialize and deserialize it. After all there are countless non-standardized formats serialized and deserialized billions of times everyday, no?

The issue arise if we work with web servers and browsers: they need to know the right [MIME type](https://datatracker.ietf.org/doc/html/rfc6838) in order to support it properly.
And since there is no standard they are either totally unsupported or supported sporadically.

At the moment ndjson is (or better SHOULD ad per spec) reported as `application/x-ndjson` and jsonl is reported as `application/jsonl` (see [this issue](https://github.com/wardi/jsonlines/issues/19) if you want to help writing the relevant RFC)

I personally prefer jsonl since it was the first one I've come across on my job... and the extension is shorter :angel:!

[^0]: I'd like to rant about the fact that the official documentation had such a format ambiguity easily fixable by using the right file extension; but the project was MIT licensed, and having neither reported nor opened a pull request for it, I can't complain.  
Moreover my employer has his "non-policies", so i just have to forget and get over it. 

[^1]: Don't confuse it with [JSON-LD](https://json-ld.org/) which is a totally different beast (that also happen to be [formally specified by W3C](https://www.w3.org/2020/08/json-ld-wg-charter.html))

[^2]: https://github.com/ndjson/ndjson-spec/issues/35#issuecomment-1285673417

[^3]: My networking teacher at University liked to say that most computer standards are the result of "*un accidente della storia*" or in english "*an accidental case of history*"