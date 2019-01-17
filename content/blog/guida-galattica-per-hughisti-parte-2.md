---
title: "Guida Galattica per Hughisti Parte 2"
date: 2019-01-15T17:17:09+02:00
draft: true
---
Primo post del 2019, nessun commento sull'anno passato, nessuna previsione sul futuro.
Solo la seconda parte della mia **guida galattica per Hughisti**!

Se siete capitati qui per puro caso e siete totalmente all'oscuro di cosa sia un sito statico o dinamico e quale sia il posto di un hughista nell'universo,
vi consiglio di leggere la [prima parte introduttiva](/blog/guida-galattica-per-hughisti-parte-1).

Prima di partire con la parte interessante riassumo i concetti chiave in modo che, anche se siete
tra i pigroni che non hanno letto la prima parte (*qualcuno da dietro vi sta fissando molto male*),
le informazioni necessarie per il proseguo dell'articolo siano tutte in questa pagina.

# Ripassino *'veloce'*

Agli albori di Internet i primi siti erano una sola raccolta di documenti html serviti da un server web puro e semplice.

Successivamente sono arrivati i primi liguaggi lato server (PHP è l'esempio più calzante) con il quale era possibile agganciare un database e generare "al volo" una pagina combinando asset e contenuti vari. Lo stack architetturale più gettonato che ha reso possibile questo artifizio è detto LAMP (Linux + Apache + MySQL + Php).

Oggigiorno la stragrande maggioranza dei siti sono dinamici, alcuni lo sono necessariamente
per le caratteristiche intrinseche (ad esempio motori di ricerca e social), altri lo sono per... boh... inerzia suppongo.

{{< figure src="/images/hard-work.jpg" caption="Photo by jesse orrico on Unsplash" >}}

Il problema fondamentale di una soluzione dinamica è che, oltre ad essere esposta a vulnerabilità (SQL injection per citarne una), richiede manutenzione che spesso non viene fatta a dovere (o per nulla).

Inoltre, dovendo generare la pagina al volo, spesso e volentieri impiega un tempo non esattamente trascurabile prima di generare le pagine da spedire. Questo è un grosso problema soprattutto per chi con un sito ci defe fare del businness, poichè un sito che impiega troppo tempo a rispondere viene abbandonato dagli utenti molto di frequente.

Ultimo, ma non meno importante è il lato economico: un servizio di hosting con tutti i crismi
può arrivare a costare parecchio.

Fatte queste dovute premesse / cenni storici veniamo al punto: qualcuno molto *smart*
ha pensato di approcciare il problema creando di fatto un ibrido: generare le pagine offline con un qualche programma ed online caricare solo il risultato, ovvero pagine HTML. Ecco quindi che sono entrati in gioco i **generatori di siti statici**.

In un colpo solo si eliminano un sacco di grane:

* no vulnerabilità
* pochissima manutenzione
* tempi di risposta dati dai soli tempi di trasferimento sulla rete internet
* costi di gestione più bassi

Questo paticolare stack non è esente da problemi e non è la soluzione ad ogni male, però calza a pennello con il tipico blog che magari è mandato avanti da una o due persone nel tempo libero.

# Hugo to the resque!

Storicamente uno dei generatori di siti statici più utilizzati è Jekyll; che è emerso anche grazie a qualche spintarella da parte di GitHub, che lo usa tuttora per erogare le [GitHub Pages](https://pages.github.com).

Via via col tempo si sono aggiunti molti altri, tanto che ora sono un [centinaio](https://www.staticgen.com).

In questa giungla c'è davvero spazio per tutti i gusti. Io tra tutti ho scelto Hugo principalmente per facilità di installazione poichè viene distribuito tramite un singolo file binario.

>  Eh finalmente! Ci sono voluti solo 3200 caratteri (spazi inclusi) per arrivare al nocciolo della questione!

Comincio subito col sottolineare che la mia esperienza con Hugo riguarda quasi solamente la creazione di contenuti
e la loro distribuzione ***nell'internet***, perciò lascio eventuali considerazioni sullo sviluppo di template ad un futuro
articolo.

Parlando in termini tecnici prende una directory con file sorgenti e template, e sforna in output un sito ben confezionato.
Prima di tutto vediamo com'è la struttura delle directory e cosa contiene ognuna.

## La struttura delle directory
Ribadendo c
