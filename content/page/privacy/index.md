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
* Il sistema di commenti [Hyvor Talk](https://talk.hyvor.com) è sempre un'offerta _privacy first_, di default non installa alcun cookie e non svolge alcun tracciamento riconducibile al singolo visitatore. Viene installato on cookie tecnico solo qualora venga effettuato un login alla loro piattaforma per commentare tramite il proprio account personale (ma ricordo che i commenti si possono lasciare anche anonimamente)


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
Per i commenti questo sito usa Hyvor Talk come piattaforma per i commenti. Questo servizio è sviluppato in Sri Lanka ma per erogare i propri  servizi utilizza server e reti 100%  europee (DigitalOcean - Francoforte) in conformità alla normativa GDPR:

* **Per i lettori**:
  * Non viene memorizzato alcun dato personale, viene solamente memorizzata la visita con fine esclusivo di identificare il tier di pagamento (eh sì, è un servizio che pago)
* **Per chi commenta**:
  * I commenti vengono analizzati da un sistema antispam sviluppato in casa da Hyvor Talk
  * Per mia scelta **non viene memorizzato** alcun indirizzo IP (che sarebbe utile per effettuare ban nel caso di spam, ma per ora non è necessario)
  * Il campo `email` è **totalmente opzionale** e viene solamente utilizzato per generare la miniatura tramite [Gravatar](https://it.gravatar.com/)
  * I cookie `authsess` viene generato **se e solo se** viene scelto di effettuare il login sul portale di Hyvor

Per ulteriori informazioni ecco la [privacy policy di Hyvor](https://talk.hyvor.com/docs/privacy).
