---
authors:
- hypertesto
categories:
- articolo
cover: /images/kelly-sikkema-273133-unsplash.jpg
date: "2019-05-05T00:00:00+02:00"
draft: true
title: Finalmente un'alternativa comoda a Disqus
---
Per parecchio tempo ho cercato un'alternativa valida a Disqus, sopratutto dopo l'avvento del famigerato nuovo regolamento europeo della privacy ([GDPR](https://eugdpr.org/ "GDPR")) entrato in vigore la primavera scorsa.

Ma facciamo un paio di passi indietro.

Come espresso sulle FAQ di Disqus, i publisher che utilizzano il servizio in SAAS devono adattarsi per chiedere il consenso per la raccolta dati ai propri lettori:

> If you are a publisher using the Disqus SaaS commenting platform, we require that you take all measures to be compliant with the GDPR as of the Effective Date. This means that you will need to implement a means to obtain consent from EU citizens for the collection of personal data on your website.

Valuto molto seriamente la mia privacy e quella dei miei pochi lettori, perciò come ho avuto modo di scrivere in precedenza, per essere adempienti e dormire sonni tranquilli è molto meglio mettersi nella situazione di non dover raccogliere il consenso: ovvero non raccogliere o passare alcun dato.

Secondariamente mi piace davvero poco che gli utenti vengano presi letteralmente per il culo con informazioni e notifiche finte.

INSERIRE IMMAGINE

POI METTERE COMPARAZIONE CON NUMERO DI RICHIESTE

### TL;DR

Prima di scendere nel dettaglio riporto a grandi linee quelli che ho scoperto giocando: o la difficolta e sulla parte di integrazione, oppure la difficolta risiede nel fatto che si deve andare di self-hosted.

### Scelta 1: integrazione con SSG

Utilizzando molto i [generatori di siti statici]() ho provato (ed e in funzione su questo blog) [Staticman](https://staticman.net/ "staticman").

Staticman funziona così:

1. Un utente preme il pulsante "commenta sul sito"
2. Viene effettuata una richiesta presso le API di staticman (`https://api.staticman.net/v2/entry/`o quella self-hosted)
3. Staticman produce un file nel repo indicato in configurazione
4. Il push nel repository triggera un nuovo build del sito (prima o poi continuero con la guida galattica, lo prometto)
5. Basta ricaricare la pagina per vedere il nuovo commento

### Scelta 2: commento

Lintegrazione con un SSG, dal mio punto di vista, e una figata ma non e la stessa cosa di Disqus. Serve qualcosa che possa essere altamente interattivo e sufficientemente generico per essere integrato senza sforzo in qualsiasi pagina. Spoiler: Javascript.
