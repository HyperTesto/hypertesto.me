---
categories:
- guida galattica per hughisti
cover: /images/ggph/ggph_cover_01.png
date: "2018-07-02T21:28:09+02:00"
draft: false
tags:
- guide
- hugo
- ssg
title: Guida Galattica per Hughisti - Parte 1
---

A distanza di mesi dal mio [primo articolo](/blog/come-ho-scoperto-i-generatori-di-siti-statici), ho deciso di scrivere una guida a puntate sull'universo dei siti statici, con un approfondimento pratico su [Hugo](https://gohugo.io).

Ho deciso di farlo principalmente per due motivi:

* la scarsità con contenuti di approfondimento in italiano (i pochi che ci sono tutti molto *SEO oriented*)
* avevo delle GIF animate pronte da un po'

La guida sarà divisa in 5 parti:

* un' introduzione teorica sulla generazione dinamica vs statica dei contenuti per il web
* una introduzione ad hugo (installazione + primi passi)
* gestione dei contenuti
* pubblicazione e hosting
* gestione di contenuti "dinamici"

Miei cari autostoppisti del web, allacciate le cinture, stiamo per partire!

## Siti dinamici

Premetto che ho riscritto questa sezione più volte poiché il mio discorso si era incasinato... ma volevo assolutamente far passare il concetto che come spesso succede, il problema cambia molto a seconda di come lo si guarda in tutte le sue sfaccettature.

### Dinamico! Non interattivo!

Sul web si trovano molte definizioni, La più semplice è sicuramente quella che definisce un sito dinamico come "interattivo per l'utente". OK... Allora sulla base di questo possiamo tranquillamente considerare anche [questo](http://info.cern.ch/hypertext/WWW/TheProject.html) come dinamico? Dopotutto ci sono davvero un sacco di link da cliccare, potete passarci tutto il fine settimana, davvero!

![that's enough internet](/images/enough_internet.jpg)

Osserviamo il problema da un altro punto di vista; questa è una delle [riposte](https://www.quora.com/What-are-examples-of-a-dynamic-website/answer/Justin-Rashidi) che si trovano su Quora:

>The main differences between a static and dynamic website is that with dynamic websites allow interaction while static websites all the information needs to be updated by an admin.

Non molto utile questa prima parte... Questo passaggio però ci viene più in aiuto:

> From a technical standpoint a dynamic website needs to have a server side language like python, ruby, php, etc and a database system that stores the dynamic information.

OK! Questo è già più utile per la distinzione che voglio fare guardando il problema dal punto di vista del **momento in cui vengono assemblati i contenuti da servire all'utente**.

Guardando il problema da questa prospettiva, si può definire dinamico il sito che "renderizza" i contenuti server side solo una volta ricevuta una richiesta da parte dell'utente.

![sito dinamico](/images/dynamic_site.gif)

Ho provato a riassumere tutto, semplificando al massimo, ricavando sostanzialmente 5 step dello scenario tipico:

1. ricezione della richiesta dall'utente (tipicamente tramite browser)
2. acquisizione degli asset (pagine HTML, immagini, codice PHP/Ruby/Java...)
3. esecuzione del codice acquisito
4. caricamento dei dati da database
5. restituzione all'utente della pagina testè assemblata

Questo scenario è spesso associato allo stack LAMP (Linux - Apache - MySQL - PHP) e, più in generale, ad architetture composte da un server WEB, un database ed un linguaggio di programmazione con cui eseguire delle operazioni.

Con questo sistema si possono servire contenuti altamente personalizzati e interattivi come ad esempio:

* Commenti
* UI personalizzata secondo preferenze
* CMS (Content Management System)
* meteo live
* ricerche

### Davvero molto bello, ma...

Ovviamente tutte queste cose belle non sono gratis: provate ad immaginare di andare al ristorante ed ordinare un risotto; la cottura del riso richiede tempo e dovrete attendere un po' prima che vi sia servito il piatto.

Lo stesso ragionamento si applica in questo caso, e assemblare i contenuti richiede tempo. Ma all'utente che (leggere con forte accento milanese) *non ha mica tempo da perdere*, non piace attendere, giusto?

Un altro punto da non sottovalutare, è che, più elementi abbiamo nell'architettura e più diventa complicato gestirli. Qualcuno di voi ha mai dedicato del tempo all'ottimizzazione di siti Wordpress? Si comincia con il rimuovere qualche plugin superfluo per poi trovarsi a sguazzare in **caching** e compressione degli asset, **cache**  delle query, supponendo ovviamente che qualcosa nel mezzo non si rompa.



Resta intesto che ci sono scenari in cui programmare un sito secondo questo paradigma è l'unica strada percorribile, come ad esempio:

* un sito di prenotazione di voli/hotel/treni
* un gestionale
* una webapp (perché usare qualche buzzword ogni tanto fa sempre bene)

Ma... Vale lo stesso per un blog? Secondo me no; almeno non per un blog personale.

## Siti statici

Bene, ora che vi ho tediato con ragionamenti contorti passiamo alla parte più semplice.

Riprendendo l'impostazione del discorso fatta poc'anzi, possiamo definire un sito come "statico" se non ha contenuti generati al momento della richiesta da parte dell'utente. Ovviamente anche qui ci sono i soliti casi limite, ma come definizione può andare benissimo per il proseguo di questa serie di articoli.

Dal punto di vista storico, questa è la prima tipologia di siti ad essere stata utilizzata; anche perché agli albori molte delle tecnologie che oggi sono utilizzate e che diamo per scontate non erano ancora state inventate.

Sotto il profilo tecnologico, quello che serve ad un sito statico sono:

* un server
* HTML
* contenuti multimediali

Per servire HTML e immagini non c'è bisogno di interpreti, database o riti voodoo: solo un server WEB opportunamente configurato.

Avere solo un componente nello stack ha l'indubbio vantaggio che richiede uno sforzo nettamente minore in termini di gestione e manutenzione, senza dimenticare anche l'enorme beneficio in termini di sicurezza: niente SQL injection, bug di programmazione o menate varie.

Ricalcando l'impostazione del paragrafo precedente, questi sono i punti salienti del processo che di generazione e consegna dei contenuti statici:

1. Generazione HTML
2. Ricezione richiesta da parte dell'utente
3. Risposta all'utente con pagina HTML

Da notare che la pagina HTML generata può essere servita più volte senza necessità di riassemblarla ad ogni richiesta.

![sito statico](/images/static_site.gif)

Chiaramente anche questo sistema ha i suoi limiti: chiunque abbia scritto siti WEB *alla vecchia maniera* converrà con me nel dire che se il numero di contenuti non è esiguo, il lavoro è molto tedioso ed incline ad errori; soprattutto se c'è un sacco di codice ripetuto ma con minime variazioni.

Questa è sicuramente una delle lacune che un sito dinamico può colmare mettendo di fatto a fattor comune gli **asset** e separando i **contenuti**, è poi il server che, opportunamente istruito con un linguaggio come ad esempio il tanto celebre PHP, li assembla in una pagina HTML tramite un **processo ripetibile** e quindi, tralasciando i BUG, non è incline ad errori di *copincollaggio*  (passatemi il termine).

### Due mondi a confronto

> Eh ma... Enrico prima critichi un sistema e poi mi critichi anche l'altro! Sei davvero un infame!

Già... sono davvero una persona brutta, però ho quasi finito il mio ragionamento, ancora un po' di pazienza.

Ora, nel mondo della programmazione esiste il concetto di **funzione**, che Wikipedia definisce così:

> In matematica, una funzione è una relazione tra due insiemi, chiamati dominio e codominio della funzione, che associa a ogni elemento del dominio uno e un solo elemento del codominio.

Nel nostro caso, il dominio è l'insieme di asset e contenuti, mentre il codominio è la pagina HTML che dobbiamo produrre.

Applicando questa definizione al nostro contesto, possiamo dire che il fattore discriminante tra dinamico e statico è il momento dell'applicazione di questa funzione:

* nei siti dinamici la funzione viene eseguita ad ogni richiesta da parte dell'utente (apri la pagina X)
* nei siti statici la funzione viene eseguita ogni qualvolta cambiano asset e contenuti.

Possiamo immaginare, semplificando un bel po', che se ci aspettiamo che l'output da dare all'utente cambi con una frequenza elevata (potenzialmente ad ogni richiesta) come ad esempio l'anagrafica di un comune o una ricerca su DucDuckGo, la generazione dinamica del sito sia sicuramente la scelta giusta (per non dire obbligata: proviamo ad immaginare se il vostro motore di ricerca dovesse pre-generare tutte le pagine per ogni possibile combinazione di chiavi di ricerca).

Viceversa, se i contenuti tra una richiesta ed un altra non variano, o variano di rado, il sito dinamico non è poi così conveniente. Proviamo ad immaginare di ricevere 1000 visite al giorno (averle!) e di pubblicare un articolo a settimana, per tutte le 7000 richieste ricevute è stato prodotta la stessa identica pagina... un vero spreco di CPU!

## Generatori di siti statici... Ma perché nessuno ci ha pensato prima?!

Ed ora finalmente veniamo al nocciolo della questione: è possibile provare a prendere il meglio dei due mondi?

È possibile farlo, ricalcando le definizioni date nel paragrafo precedente, applicando una funzione che, presi asset e contenuti, genera l'HTML *offline* ovvero in un flusso di lavorazione totalmente sconnesso dalla richiesta fatta dall'utente.

L'idea di base è avere un programma da lanciare a mano o con qualche meccanismo semi-automatico, che genera l'HTML che poi è possibile pubblicare con il sistema che si preferisce. Questo programma viene chiamato generatore di siti statici, abbreviato con l'acronimo anglosassone "SSG" (Static Site Generator).

![ssg-vs-dynamic](/images/ssg-vs-dynamic.png)

Di SSG ce ne sono a bizzeffe e se ne continuano ad aggiungere di nuovi. Ho scelto Hugo tra i tanti é:

* È leggero
* **È facile da installare**
* La documentazione è molto buona
* Genera le pagine in un tiro di schioppo
* Ci sono un sacco di ottimi template già fatti

Il flusso di lavoro tipico prevede la generazione dei contenuti su una macchina (anche il proprio PC) e la successiva pubblicazione, che essendo svincolata da linguaggi di programmazione, può essere effettuata **#aggratis** su servizi come ad esempio [GitHub Pages](https://pages.github.com/) o su [Netlify](https://www.netlify.com/), per citarne un paio.

Un altra cosa furba (come avevo già scritto nel mio [primo articolo](/blog/come-ho-scoperto-i-generatori-di-siti-statici)), è che il flusso di lavoro tipico prevede l'utilizzo di **Git**; così **#aggratis** ci siamo anche messi al riparo da perdite di dati accidentali.

Infine, il fatto di avere la generazione del contenuto svincolata dalla sua distribuzione permette di concentrarsi su aspetti più legati alla performance come ad esempio le cache dei browser piuttosto che la distribuzione dei contenuti tramite CDN (Content Delivery Network).

Per questa prima parte è tutto, probabilmente non ci avrete capito una mazza, ma non è stato facile concentrare tutti i concetti in così poco spazio! Giuro che le prossime puntate saranno molto pratiche.


## Compiti per casa:

* https://www.w3.org/History.html
* https://www.webpagefx.com/blog/web-design/the-history-of-the-internet-in-a-nutshell/
* https://www.staticgen.com/
* https://jamstack.org/
* https://creativestate.com/blog/Have-You-Lived-The-Wordpress-Diy-Nightmare
* https://www.yottaa.com/benchmarking-performance-of-8-cms-platforms-who-is-slowest/
* https://securityintelligence.com/news/new-year-new-problems-cms-vulnerabilites-take-on-2016/
