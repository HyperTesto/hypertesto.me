---
title: "One login to rule them all: centralized auth for internal tools with Caddy"
date: 2026-05-19T22:30:18+02:00
draft: false
description: "How to protect internal tools behind Caddy using your company's OAuth2 provider, so you never have to implement authentication ever again"
tags:
    - linux
    - programming
categories:
    - post
authors: hypertesto
---
I am lazy. Not in the _"I don't want to work"_ sense[^1], but in the _"I refuse to solve the same problem twice"_ sense. 
So when I found myself looking at a growing collection of internal tools (each one either completely unprotected or with its own half-baked auth bolted on) I decided it was time to stop and fix it properly.

The dream: one login, backed by the identity provider the company already uses, and every new tool just gets two lines in a config file. No user databases to maintain, no password reset flows to implement, no _"hey can you add my colleague to the thing"_.

In our case the company uses Azure AD, so the plan was to put everything behind Caddy and add OAuth2 authentication against the existing Microsoft tenant. This post is about how that works and the two things that needed some extra attention to get right.

## Why Caddy

I've been through the nginx phase. The Apache phase. The _"let me just write a quick script to renew certificates"_ phase. 
At some point you just want something that works without making you feel like you're filing paperwork.

Caddy hits a sweet spot I haven't found elsewhere: it's simple enough that you can read the whole config and understand it in one sitting, 
but complete enough that you rarely need to reach for anything else. The Caddyfile syntax is human-readable by design, and the defaults are sane, 
which sounds like a low bar until you've spent an afternoon debugging a cipher suite.

The thing that genuinely removes the most friction though is automatic HTTPS. Point a domain at your server, add it to the Caddyfile, 
and Caddy handles the Let's Encrypt certificate negotiation, renewal, and everything in between. No certbot cron jobs, no `--nginx` flags, 
no "oh the cert expired over the weekend" incidents. It just works, and it keeps working.[^2]

## The pieces
- [Caddy](https://caddyserver.com/) as reverse proxy
- [Caddy-security](https://github.com/greenpau/caddy-security) (also known as AuthCrunch) for authentication and authorization. It plugs directly into Caddy and adds an authentication portal with OAuth2/OIDC support.

## Installation
Caddy supports plugins that get compiled directly into the binary. The canonical way to do this is `xcaddy`, a build tool that fetches 
the plugins you want and compiles everything from source. It works, but it requires a Go toolchain on the server, the build takes a 
few minutes, and, going back to the laziness point, it's one more thing to maintain.

The alternative is the official download page on the Caddy website. Select your platform, tick the plugins you want, and it hands you a 
pre-built binary. That's it. No Go installation, no waiting, no fuss.

Head to the download page, select Linux amd64 (or your platform), add github.com/greenpau/caddy-security, and download. Then install it:

```bash
sudo install /path/to/download /usr/bin/caddy
```

On SELinux-enabled systems (Fedora, RHEL and friends) you also need to label the binary correctly, otherwise systemd will refuse to run it:
```bash
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/caddy
```

## Setting up the service
Caddy doesn't run as root. The recommended approach is a dedicated system user with no login shell and a home directory where Caddy 
can store certificates and other state:

```bash
sudo groupadd --system caddy

sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy
```

Create the config directory:

```bash
sudo mkdir -p /etc/caddy
sudo touch /etc/caddy/Caddyfile
sudo chown -R caddy:caddy /etc/caddy
```

The official Caddy repository ships a ready-made systemd unit file, so grab that rather than writing one from scratch:

```bash
sudo curl -o /etc/systemd/system/caddy.service \
    https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service
```

The relevant bits of the unit file:

```bash
[Service]
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile --force
```

`ExecReload` is worth noting: `systemctl reload caddy` does a graceful config reload without dropping connections.
You'll use this constantly while tweaking the Caddyfile.

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
sudo systemctl status caddy
```

Logs go through journald:

```bash
journalctl -u caddy -f
```

## How caddy-security works
The plugin introduces three concepts that work together:

- **Identity provider**: where users actually authenticate. In our case Azure AD via OAuth2, but it works with any OIDC-compliant 
provider or even a local user database if you need a fallback.
- **Authentication portal**: the login page. It ties together one or more identity providers, manages session cookies, and handles 
the OAuth2 callback. It lives on a dedicated subdomain (e.g. `auth.yourdomain.com`).
- **Authorization policy**: the bouncer. Applied per-service, it checks whether the current user has the required roles and redirects to the portal if not.

## Azure AD setup
Before touching the Caddyfile, register an application in the Azure Portal:

1. Azure Active Directory → App registrations → New registration
2. Name: anything sensible
3. Supported account types: Accounts in this organizational directory only 
4. Redirect URI (Web): `https://auth.yourdomain.com/oauth2/azure/authorization-code-callback`

Once created, note down the Application (client) ID and Directory (tenant) ID from the Overview page. Then go to Certificates & secrets → New client secret 
and copy the Value immediately; **it's only shown once**.[^3]

Under API permissions add the Microsoft Graph delegated permissions: `openid`, `email`, `profile`, `User.Read`, and grant admin consent.

## The Caddyfile

```bash
{
    email your@email.com
    order authenticate before respond
    order authorize before reverse_proxy

    security {
        oauth identity provider azure {
            realm azure
            driver azure
            client_id YOUR_CLIENT_ID
            client_secret YOUR_CLIENT_SECRET
            tenant_id YOUR_TENANT_ID
            scopes openid email profile
            enable logout
        }

        authentication portal myportal {
            crypto default token lifetime 28800
            crypto key sign-verify YOUR_JWT_SECRET
            enable identity provider azure
            cookie domain yourdomain.com
            cookie path /
            cookie lifetime 28800
            cookie samesite lax
            cookie guess domain
            trust login redirect uri domain suffix yourdomain.com path prefix /

            ui {
                links {
                    "My App" https://myapp.yourdomain.com
                }
            }
        }

        authorization policy protected_services {
            set auth url https://auth.yourdomain.com/login
            enable login hint
            allow roles authp/guest user admin
            crypto key verify YOUR_JWT_SECRET
        }
    }
}

auth.yourdomain.com {
    authenticate with myportal
}

# Protected
myapp.yourdomain.com {
    authorize with protected_services
    reverse_proxy 10.0.0.2:8080
}

anothertool.yourdomain.com {
    authorize with protected_services
    reverse_proxy 10.0.0.3:3000
}
```
Generate the JWT secret with `openssl rand -base64 32`.

### Two things that needed extra attention

#### Role remapping is broken in recent builds
`caddy-security` has a transform user directive that lets you promote authenticated users to named roles based on their email domain:

```bash
transform user {
    suffix match email @yourdomain.com
    action add role user
}
```

In theory this is the right tool: map everyone from your organization to the user role, restrict the authorization policy to allow roles 
user admin, and anyone outside your tenant gets nothing even if they somehow authenticated. Clean and explicit.

In practice, as of the current build, the transform doesn't reliably fire after an OAuth2 login. Users end up with only the default 
authp/guest role regardless of what the transform says, which means a policy that only allows user will lock everyone out; including 
the people you just spent an afternoon trying to let in.

The workaround is to allow authp/guest in the authorization policy. It's not as granular as role mapping, but given that the OAuth2 
provider is already scoped to a single tenant, any user who successfully authenticates is implicitly trusted, the gatekeeping is happening 
at the Azure level anyway.

This does mean that in practice everyone in the same Azure AD tenant gets access to all protected services. For us that's fine: we're a small 
team and internal tools are, well, internal. But the building blocks for something more structured are already there: once transform user is 
reliable again, you can map roles per email domain, per specific user, or combine multiple policies to restrict individual services to specific 
groups. The concept scales, even if the current implementation needs a nudge.

Keep an eye on the [issue tracker](https://github.com/greenpau/caddy-security/issues) if fine-grained role mapping matters for your use case.

#### Cookies and post-login redirects
Two things need to be correct for the flow to work end to end.

The first is cookie scoping. After login, the browser needs to send the access token cookie to all protected subdomains, not just `auth.yourdomain.com`. 
`cookie guess domain` handles this automatically. Without it, every request to a protected service finds no token and loops back to the login page indefinitely 
(which is as fun as it sounds).

A counterintuitive note from the official docs: don't use a leading dot (`.yourdomain.com`) for cookie domain. Despite being standard practice in most contexts, 
the plugin doesn't support it and things break silently.

The second is the post-login redirect. After a successful login you'd expect to land on the page you were originally trying to reach. Without the right 
configuration you land on the portal homepage instead, which is _anti-climactic_. Two things are needed in combination: `set auth url` must point to `/login` 
explicitly (not just the root domain), and the portal needs to know which redirect destinations are trusted:

```bash
trust login redirect uri domain suffix yourdomain.com path prefix /
```

Without this the portal ignores the `redirect_url` query parameter entirely.

## The final result
The next time someone asks for a new internal tool, the answer is: spin it up, add two lines to the Caddyfile, reload. 
No user database, no password reset flow; _nothing_.  
Everyone with a company account can log in, everyone else can't.  

I also added `enable login hint` so in case anyone needs to login after the previous session expired, it will be presented with the Azure AD login page already filled
with the account of the expired session: easy and effecient.

My laziness form is now complete. Larry Wall would be proud.[^4]

[^1]: Well, not _only_ in that sense.
[^2]: Caddy also gets an A+ on SSL Labs out of the box, in case you needed another reason.
[^3]: There are two columns: Secret ID (a GUID) and Value (a long random string). You want the Value. Using the ID will give you a cryptic `AADSTS7000215` error and a solid fifteen minutes of confusion.
[^4]: Larry Wall, creator of Perl, listed the three virtues of a programmer as: Laziness, Impatience, and Hubris. Laziness is first. We are vindicated
