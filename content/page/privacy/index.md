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
## In soldoni

Come qualsiasi altro sito web, da qualche parte alcuni dati transitano e altri vengono elaborati e memorizzati. Ho cercato di essere il più efficiente e trasparente possibile su questo tema cercando in tutti i modi di non tracciarvi o installarvi porcherie: questo sito non utilizza Google Analytics o cookie di terze parti dei social network.  

* Il sito è hostato su [Netlify](https://www.netlify.com) che può memorizzare alcune informazioni, tra cui l'IP di origine delle richieste alle pagine, nei propri _access log_ per un periodo di 30 giorni
* Per avere una stima sulle visite delle pagine utilizzo [Plausible Analytics](https://plausible.io), un servizio _privacy first_ completamente hostato in Europa e che non colleziona dati sensibili o fa uso di cookie.
* Come sistema di commenti, utilizzo un'istanza di Remark42 auto-ospitata; si tratta di un software open source estremamente attento alla privacy.


## Cookie

Non vengono installati cookie di nessun tipo con l'eccezione dell'autenticazione per i commenti, che è totalmente opt-in, e installa solamente due cookie con finalità esclusivamente tecniche come definito nella [relativa sezione](#commenti).

## Hosting
Il sito è hostato tramite [Netlify](https://www.netlify.com). Netlify in qualità di CDN/Host non effettua alcun tracciamento o elaborazione per mio conto.
Può, come ogni servizio di questo tipo, memorizzare alcuni log per fini di debug e di esigenze di funzionamento.

Un log è un elenco cronologico di messaggi prodotti da uno o più software; spesso tali messaggi sono memorizzati in un file normale di testo.  

Un messaggio di log nell'ambito di un server WEB normalmente riporta informazioni circa l'IP sorgente, il path e la query string:  

```47.29.201.179 - - [28/Feb/2019:13:17:10 +0000] "GET /?p=1 HTTP/2.0" 200 5316 "https://domain1.com/?p=1" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36" "2.75"```

Nel caso specifico Netlify memorizza l'IP sorgente.
Per maggiori dettagli è possibile consultare la loro [pagina dedicata al GDPR](https://www.netlify.com/gdpr-ccpa/).

## Statistiche
Per le statistiche di utilizzo del sito utilizzo Plausible Analytics che è un tool per le statistiche compatibile con GDPR, CCPA e la cookie law (ed è anche [open source](https://github.com/plausible/analytics)).
I dati collezionati sono i seguenti:

* URL della pagina: questo è il dato di maggior interesse per la raccolta di dati (per la verità anche l'unico che mi interessa), questo dato è ripulito da qualsiasi query string (che potrebbe potenzialmente riportare dati sensibili)
* Referer HTTP: la pagina di provenienza se presente
* Browser: derivato dall'header HTTP `User-Agent` (che non viene memorizzato)
* Sistema Operativo: derivato dall'header HTTP `User-Agent` (che non viene memorizzato)
* Tipo di device: è **stimato** dalla larghezza della finestra (che non viene memorizzata)

Per **stimare** in modo sufficientemente preciso i visitatori unici non vengono utilizzati cookie o _device-persistent identifier_, ma vengono invece anonimizzati alcuni dati presenti in ogni richiesta HTTP tramite una funzione di hash:

```hash(daily_salt + website_domain + ip_address + user_agent)```

L'esigenza non è identificare gli utenti, ma piuttosto avere un'idea spannometrica delle pagine più visitate. Per questo motivo ho reso pubblica la [dashboard con i dati collezionati](https://plausible.io/hypertesto.me).

Per ulteriori informazioni questa è la  [Privacy Policy completa di Plausible](https://plausible.io/data-policy).

## Commenti

Come sistema di commenti, utilizzo [Remark42](https://remark42.com/). Ho auto-ospitato questo servizio in un cloud privato sicuro in Europa (per essere più specifici, in Italia) e i backup sono conservati presso lo stesso provider italiano.

Remark42 cerca di essere molto sensibile riguardo a qualsiasi informazione privata o semi-privata:

- L'autenticazione richiede il minimo accesso possibile dai fornitori di autenticazione, e tutte le informazioni extra restituite da essi vengono immediatamente eliminate e non memorizzate in alcuna forma.
- In generale, Remark42 conserva solo l'ID utente, il nome utente e il link all'avatar. Nessuno di questi campi viene esposto direttamente: **ID e nome sono criptati, l'avatar è trasmesso tramite proxy.**
- **Non viene effettuato alcun tracciamento di sorta.**
- Il meccanismo di accesso utilizza un JWT memorizzato in un cookie (JWT, HttpOnly, protetto). Il secondo cookie (XSRF_TOKEN) è un ID casuale che previene CSRF. Entrambi i cookie sono associati al dominio `remark42.hypertesto.me`.
- Non è possibile effettuare un login *cross-site*, ovvero il comportamento dell'utente non può essere analizzato su siti indipendenti che utilizzano Remark42.
- Tutti i dati potenzialmente sensibili memorizzati da Remark42 sono criptati e resi in forma di hash.

Remark42 ti consente anche di fare due cose (che sono anche tuoi diritti da GDPR):

- Puoi richiedere tutte le informazioni che Remark42 ha su di te e riceverle in un file gz (esportazione).
- Puoi richiedere la cancellazione di tutte le informazioni che ti riguardano tramite una richiesta di tipo "deleteme".

Potresti ricevere notifiche via email solo in queste circostanze:

- Decidi di effettuare l'accesso tramite email (opt-in).
- Decidi di effettuare l'accesso tramite Telegram (opt-in, @hypercomments_bot).
- Decidi di ricevere le notifiche via mail per le nuove risposte ai tuoi commenti (opt-in, e puoi disiscriverti seguendo il link presente nell'email).

Le email transazionali vengono inviate come definito nella sezione successiva.

## Email transazionali

Le email transazionali vengono inviate utilizzando un servizio europeo conforme al GDPR: [Scaleway TEM](https://www.scaleway.com/en/transactional-email-tem/).

Le email vengono inviate dal dominio `remark42.hypertesto.me` con autenticazione SPF e DKIM al fine di migliorare la consegna delle email, rilevare eventuali falsificazioni e prevenire lo spam.