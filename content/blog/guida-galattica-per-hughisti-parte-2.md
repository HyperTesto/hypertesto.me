---
title: Guida Galattica per Hughisti Parte 2
date: 2019-01-15T15:17:09.000+00:00
draft: true

---
Ciao, questa è la seconda parte della mia **guida galattica per Hughisti**!

Se siete capitati qui per puro caso e siete totalmente all'oscuro di cosa sia un sito statico o dinamico e quale sia il posto di un hughista nell'universo,
vi consiglio di leggere la [prima parte introduttiva](/blog/guida-galattica-per-hughisti-parte-1).

Prima di partire con la parte interessante riassumo i concetti chiave in modo che, anche se siete tra i pigroni che non hanno letto la prima parte (_qualcuno da dietro vi sta fissando molto male_), le informazioni necessarie per il proseguo dell'articolo siano tutte in questa pagina.

# Ripassino _'veloce'_

Agli albori di Internet i primi siti erano una sola raccolta di documenti html serviti da un server web puro e semplice.

Successivamente sono arrivati i primi linguaggi lato server (PHP è l'esempio più calzante) con il quale era possibile agganciare un database e generare "al volo" una pagina combinando asset e contenuti vari. Lo stack architetturale più gettonato che ha reso possibile questo _artifizio_ è detto LAMP (Linux + Apache + MySQL + Php).

Oggigiorno la stragrande maggioranza dei siti sono dinamici, alcuni lo sono necessariamente per le loro caratteristiche intrinseche (ad esempio motori di ricerca e social), altri lo sono per... boh... inerzia suppongo.

{{< figure src="/images/hard-work.jpg" caption="Photo by jesse orrico on Unsplash" >}}

Il problema fondamentale di una soluzione dinamica è che, oltre ad essere esposta a varie vulnerabilità (SQL injection per citarne una), richiede manutenzione che spesso non viene fatta a dovere (o per nulla).

Inoltre, dovendo generare la pagina _al volo_, spesso e la richiesta impiega un tempo non esattamente trascurabile prima di essere servita all'utente. Questo è un grosso problema soprattutto per chi con un sito ci deve fare del businness, poichè un sito che impiega troppo tempo a rispondere viene abbandonato dagli utenti con un tasso particolarmente elevato (e qui l'esempio calzante è quello del negozio: la gente si spazientisce se il commesso non è subito disponibile).

Ultimo, ma non meno importante è il lato economico: un servizio di hosting con tutti i crismi può arrivare a costare parecchio.

Fatte queste dovute premesse / cenni storici veniamo al punto: qualcuno molto _smart_
ha pensato di approcciare il problema creando di fatto un ibrido: generare le pagine offline con un qualche programma ed online caricare solo il risultato, ovvero pagine HTML. Ecco quindi che sono entrati in gioco i **generatori di siti statici**.

In un colpo solo si eliminano un sacco di grane:

* no vulnerabilità
* pochissima manutenzione
* tempi di risposta dati dai soli tempi di trasferimento sulla rete internet
* costi di gestione più bassi

Questo particolare stack non è esente da problemi e non è la soluzione ad ogni male, però calza a pennello con il tipico blog che magari è mandato avanti da una o due persone nel tempo libero.

# Hugo to the resque!

Storicamente uno dei generatori di siti statici più utilizzati è Jekyll; che GitHub, usa tuttora per erogare le [GitHub Pages](https://pages.github.com).

Via via col tempo si sono aggiunti molti altri, tanto che ora sono un [centinaio](https://www.staticgen.com).

In questa giungla c'è davvero spazio per tutti i gusti. Io tra tutti ho scelto Hugo principalmente per facilità di installazione poiché viene distribuito tramite un singolo file binario.

> Eh finalmente! Ci sono voluti solo 3200 caratteri (spazi inclusi) per arrivare al nocciolo della questione!

Comincio subito col sottolineare che la mia esperienza con Hugo riguarda quasi solamente la creazione di contenuti e la loro distribuzione, perciò lascio eventuali considerazioni sullo sviluppo di template ad un futuro articolo.

Parlando in termini tecnici, Hugo prende una directory con file sorgenti e template, e sforna in output un sito ben confezionato. Perciò prima di tutto vediamo cosa contiene un progetto hugo appena sfornato.

## La struttura delle directory

In Hugo i contenuti vengono strutturati in questo modo:

```
    .
    ├── archetypes
    ├── assets
    ├── config
    ├── content
    ├── data
    ├── layouts
    ├── static
    └── themes
```

La struttura dovrebbe essere abbastanza autoesplicativa. Per un'utilizzo basilare, come ad esempio la semplice stesura di articoli, le cartelle che si utilizzano sono:

* **content:** in questa directory trovano spazio i file markdown contenenti gli articoli e le pagine
* **static:** qui vengono messi file e immagini da includere nel sito
* **themes:** qui vengono memorizzati i temi da utilizzare

Le altre cartelle contengono dati ed istruzioni per un'utilizzo più avanzato, come ad esempio la personalizzazione dei campi custom (archetypes), oppure layout personalizzati sulla base del tipo di articolo.

Una volta generato il sito, la posizione di default dei file HTML è la cartella **public**.

## Partenza in quarta
Ora che sappiamo cosa troveremo una volta creato un progetto Hugo per la prima volta, non ci resta che provare!
Per proseguire con il resto della guida avrete bisogno di:

* un po' di dimestichezza con il terminale
* git installato e funzionante


Per prima cosa occorrerà installare Hugo seguendo la [guida ufficiale](https://gohugo.io/getting-started/installing/) per il vostro sistema operativo.

Una volta installato potete verificare che tutto funziona con il comando:
```bash
$ hugo version
```
Al momento della stesura dell'articolo, l'ultima versione disponibile è òa `0.55`, perciò se avete fatto tutto come si deve dovreste ottenere una versione uguale o superiore.

Per creare lo scheletro del progetto, da terminale digitare:
```bash
$ hugo new site ilmiobelsito
```
Verrà creata una nuova cartella `ilmiobelsito` nella posizione attuale. Il contenuto della cartella è quello affrontato nel paragrafo precedente.

Spostiamoci nella cartella del progetto con
```bash
$ cd ilmiobelsito
```
E 

