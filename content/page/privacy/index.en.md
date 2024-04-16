---
date: "2022-06-01T00:51:06+02:00"
draft: false
showComments: false
sharingLinks: false
title: Privacy
layout: "simple"
menu:
  footer:
    weight: 10
---
## In a nutshell

Like any other website, certain data is transmitted and processed while other is stored. I have tried to be as efficient and transparent as possible on this issue, making every effort not to track or install anything intrusive: this site does not use Google Analytics or third-party cookies from social networks.

- The website is hosted on [Netlify](https://www.netlify.com/), which may store some information, including the IP address of requests to the pages, in its access log for a period of 30 days.
- To estimate page visits, I use [Plausible Analytics](https://plausible.io/), a privacy-first service hosted entirely in Europe that does not collect sensitive data or use cookies.

- As a commenting system I use a self-hosted [Remark42](https://remark42.com/) instance which is privacy-first and open source software.

## Cookies

No cookies of any kind are installed, except for authentication for comments, which is entirely opt-in, and it only installs two cookies for purely technical purposes, as defined in the [relevant section](#comments).

## Hosting
The site is hosted through [Netlify](https://www.netlify.com/). Netlify, as a CDN/Host, does not track or process data on my behalf. Like any service of this kind, it may store some logs for debugging purposes and operational needs.

A log is a chronological list of messages produced by one or more software systems; often these messages are stored in a regular text file.

A log message within the context of a web server usually includes information about the source IP, path, and query string:

`47.29.201.179 - - [28/Feb/2019:13:17:10 +0000] "GET /?p=1 HTTP/2.0" 200 5316 "https://domain1.com/?p=1" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" "2.75"
`

In this specific case, Netlify stores the source IP. For more details, you can consult [their dedicated GDPR page](https://www.netlify.com/gdpr-ccpa/).

## Statistics

For website usage statistics, I use Plausible Analytics, a privacy-first service completely hosted in Europe that does not collect sensitive data or use cookies (it's [open source](https://github.com/plausible/analytics)!). The collected data includes:

- Page URLs: this is the most relevant data for data collection (in truth, it's the only data of interest to me). This data is cleaned of any query string (which could potentially contain sensitive information).
- HTTP Referrer: the referring page, if present.
- Browser: derived from the HTTP `User-Agent` header (which is not stored).
- Operating System: derived from the HTTP `User-Agent` header (which is not stored).
- Device Type: **estimated** from the window width (which is not stored).

To **estimate** unique visitors accurately, no cookies or device-persistent identifiers are used. Instead, certain data present in each HTTP request is anonymized using a hash function:

`hash(daily_salt + website_domain + ip_address + user_agent)`

The purpose is not to identify individual users but to get a rough idea of the most visited pages. For this reason, I have made [the dashboard with the collected data public](https://plausible.io/hypertesto.me).

For further information, you can refer to [Plausible's complete Privacy Policy](https://plausible.io/data-policy).

## Comments

As a commenting system, I use [Remark42](https://remark42.com/). I self-hosted this service in a secure private cloud in Europe (Italy to be more specific) and backup are also stored on the same Italian provider.

Remark42 is trying to be very sensitive to any private or semi-private information:
- Authentication is requesting the minimal possible scope from authentication providers and all extra information returned by them is immediately dropped and not stored in any form.
- Generally, Remark42 keeps user ID, username and avatar link only. None of these fields exposed directly - **ID and name hashed, avatar proxied**.
- There is **no tracking of any sort**.
- Login mechanic uses JWT stored in a cookie (JWT, HttpOnly, secured). The second cookie (XSRF_TOKEN) is a random ID preventing CSRF. Both the cookies are associated to domain `remark42.hypertesto.me`.
- There is no cross-site login, i.e., user's behavior can't be analyzed across independent sites running Remark42.
- All potentially sensitive data stored by Remark42 hashed and encrypted.

Remark42 also let you do those two things (which also happen to be your rights as defined in GDPR):
- You can request all information Remark42 knows about them and receive the export in the gz file.
- You can request a cleanup of all information related to you with a "deleteme" request.

You may receive mail notification only under these circumstances:
- You choose to log in using email (opt-in)
- You choose to log in using Telegram (opt-in, @hypercomments_bot)
- You choose to receive mail notifications on new responses to your comments (opt-in, and you can unsubscribe following the link inside the email)

Transactional mail are sent as defined in the next section

## Transactional email
Transactional email are sent using a GDPR-compliant european service: [Scaleway TEM](https://www.scaleway.com/en/transactional-email-tem/).

Mail are delivered from domain `remark42.hypertesto.me` with SPF authentication and DKIM in order to improve email deliverability, detect forgery, and prevent spam.