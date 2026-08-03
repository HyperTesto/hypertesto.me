---
title: "Curlese, five years later: curl is still the unversal language of broken integrations"
date: 2026-08-03T18:00:00+02:00
draft: false
description: "Five years ago I argued that curl is the only language every team speaks when an integration breaks. A revisit: what changed, what didn't, and the 2026 survival kit."
tags:
  - curl
  - debugging
  - http
  - integrations
  - api
categories:
  - post
authors:
  - hypertesto
---
Almost five years ago I wrote a post (in Italian) about what I jokingly called *curlese*: the practice of using `curl` as a universal language when an HTTP integration breaks and you need to figure out whose fault it is.[^0] The idea was simple: instead of arguing with a provider over log files they don't want to read, you send them a curl command. It's self-describing, it's reproducible, and — crucially — it's not *your* code, so nobody can dismiss it as "your application is buggy".

[^0]: The original post is [here](/blog/il-curlese-come-lingua-franca/), if you read Italian. *Curlese* doesn't really translate; it's "curl" turned into a language name, with verbs like *curlare* and nouns like *curlata* (a single curl invocation, usually performed in anger).

Five years later, I can confirm the thesis held up embarrassingly well. I still do this constantly. But the world around the thesis changed quite a bit, so it's time for an update: what changed, what didn't, and what my survival kit looks like in 2026.

## What didn't change

The social problem is exactly where I left it. Every integration still involves at least two teams, one firewall nobody fully understands, and a conversation that starts with "works on my side". Your perfectly clear application logs are still worthless in that conversation, because:

- the other side can't (or won't) interpret your logs
- it's always easier to assume the problem is you
- you're rarely talking to the person who can actually fix it

A curl command with its output solves all three. It's executable evidence. You can paste it in a ticket, the other team's network admin can run it as-is, and the verdict is written in plain text. This part of the post needs no update at all, which is either reassuring or depressing depending on your mood.

## What changed

Quite a lot, actually.

**HTTP/2 is everywhere, HTTP/3 is no longer exotic.** In 2021 a plain HTTP/1.1 exchange was the norm for the kind of integrations I deal with. Now I regularly hit endpoints that negotiate HTTP/2, and occasionally ones where ALPN itself is part of the problem. When a request works from your laptop but hangs from a server, "they speak different HTTP versions" is now a legitimate suspect.

**mTLS went from exotic to Tuesday.** Client certificates used to be a once-a-year annoyance. Now every second B2B integration wants mutual TLS, which means a whole new category of failures (and of curl flags) that my 2021 self didn't cover.

**Everything is behind a WAF, a proxy, or an API gateway.** Which means the error you get is often not from the application but from a bouncer in front of it, with its own ideas about which User-Agent strings deserve to exist. I once spent an afternoon proving that an endpoint worked: the provider's edge just didn't like a specific client. The fix was literally changing a header. The proof, as usual, was a pair of curl commands differing by one flag.

**The lingua franca gained a new speaker.** In 2026, the entity you're explaining the problem to is increasingly not a human. A curl command with `-v` output is the perfect thing to paste into an LLM when you're stuck: it's complete, unambiguous context with zero setup. Turns out the same properties that make curl ideal for tickets make it ideal for prompts. The machines, too, speak curlese.

## The 2026 survival kit

Everything from the old post still applies (`-v`, `-k`, `--connect-timeout`, `--trace-ascii`, `--trace-time` — the last one saved me just a few months ago while chasing phantom delays). Here's what earned a permanent spot since then:

| Flag | Why it's in the kit |
|---|---|
| `-w '%{time_total} %{time_connect} %{time_appconnect}'` | Timing breakdown. The difference between "your server is slow" and "your *TLS handshake* is slow" is the difference between a ticket that goes nowhere and one that gets fixed. |
| `--resolve host:port:ip` | Test a specific IP with the correct SNI/Host, bypassing DNS. Essential when DNS is load-balanced and only *some* backends are broken. |
| `--connect-to ::alt-host:` | Same family: redirect the connection elsewhere while keeping headers intact. Great for testing a staging backend with production URLs. |
| `--cert client.pem --key client.key` | mTLS. Half the time the failure is the certificate chain, and curl tells you exactly which certificate it sent and what the server said about it. |
| `--json` | Sets `Content-Type: application/json` and POSTs the data. Small thing, but it removes a whole class of "you forgot a header" mistakes when writing repro commands. |
| `--fail-with-body` | Exit code reflects the HTTP status, but you still see the error response body. Perfect for scripts *and* for humans. |
| `--retry 5 --retry-all-errors` | "It fails *sometimes*" is no longer an acceptable bug report. Let statistics do the talking. |
| `--no-alpn` | For those special afternoons when you suspect the HTTP version negotiation itself is the problem. Rare, but when you need it, nothing else will do. |

A note on `-w`: the format string is fully customizable and criminally underused. `curl -o /dev/null -s -w 'dns:%{time_namelookup} connect:%{time_connect} tls:%{time_appconnect} total:%{time_total} http:%{http_code}\n' https://example.com` gives you a one-line performance autopsy of any endpoint. I have this as a shell alias.[^3] So should you.

[^3]: It's called `curlopsy` (curl + autopsy). Yes, it's a terrible name. No, I'm not changing it: it has outlived two laptops, and at this point it has seniority.

## The dictionary, updated

The old post had a list of frequent error messages and their usual causes. Here's the 2026 edition, same format with symptom first and likely culprit second:

| Symptom | Probably means |
|---|---|
| `connection timed out` | No network path. Firewall, routing, or the service is down. Still the #1 hit. |
| `connection refused` | Path exists, nothing listening on that port. Service down or wrong port. |
| `SSL certificate problem: unable to get local issuer certificate` | Self-signed cert or a CA your trust store doesn't know. Classic, eternal. |
| `sslv3 alert handshake failure` / `curl: (35)` | TLS versions or cipher suites don't overlap. Often an ancient server meeting a modern client, or vice versa. |
| `wrong version number` | You're speaking TLS to a plain HTTP port. Or there's a proxy mangling things in the middle. |
| HTTP/2 stream errors / resets that vanish with `--http1.1` | A middlebox or server with a buggy HTTP/2 implementation. Downgrade and retest before accusing anyone. |
| `403` with an HTML page from a product you've never heard of | That's the WAF. Read the page: it usually names the vendor, which tells you *whose* edge is blocking you. |
| It works with `--insecure` but not without | Certificate chain issue. Now you know exactly where to dig. |

## Spreading the word, reloaded

The old post closed with a list of phrases to request a curl session from your interlocutors. They were untranslatable then and they're untranslatable now, so here's the 2026 English starter pack:

- *"Can you curl it from your side and paste the output in the ticket?"*
- *"Let's both run the same command and compare notes."*
- *"Send me the `-v` output, not a screenshot of Postman."*[^1]
- *"You either curl it yourself, or I will curl the hell out of you."*[^2]

[^1]: Nothing against Postman. But a screenshot of a GUI is not a reproducible test case, and you know it.

[^2]: Delivery matters: deadpan, in writing, and only with someone you've already survived at least one incident bridge with. HR departments are notoriously not fluent in curlese.

Five years on, my advice is unchanged: when an integration breaks, don't argue, *curl it*! The command is the contract, the output is the verdict, and the ticket resolves itself. Some technologies come and go; the humble curl invocation, apparently, is forever.

Thanks for reading. And now go spread the verb![^4]

[^4]: Yes, *verb*. The Italian original closed with *"diffondete il verbo!"* — and in Italian *verbo* means both "the word" and "the verb", which makes it the only correct translation. `curl` is a verb now, conjugate it proudly.
