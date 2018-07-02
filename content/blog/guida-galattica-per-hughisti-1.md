---
title: "Guida Galattica per hughisti - Parte 1"
date: 2018-06-27T21:28:09+02:00
cover: /images/dont_panic_hugo_part_1.jpeg
draft: true
---

A distanza di mesi dal mio [primo aricolo](/blog/come-ho-scoperto-i-generatori-di-siti-statici), ho deciso di scrivere una guida a puntate sull'universo dei siti statici, con un approfondimento pratico su [Hugo](https://gohugo.io).

Ho deciso di farlo principalmente per due motivi:

* la scarsità con contenuti di approfondimento in italiano (i pochi che ci sono sono tutti molto *SEO oriented*)
* avevo delle GIF animate pronte da un po'

La guida sarà divisa in 5 parti:

* un' introduzione teorica sulla generazione dinamica vs statica dei contenuti per il web
* una introduzione ad hugo (installazione + primi passi)
* gestione dei contenuti
* pubblicazione e hosting
* gestione di contenuti "dinamici"

Miei cari autostoppisti del web, allacciate le cinture, stiamo per partire per il nostro viaggio!

## Siti dinamici

Premetto che ho riscritto questa sezione più volte poichè il mio discorso si era incasinato... ma volevo assoulutamente far passare il concesso che, come spesso succede, il problema cambia molto a seconda di come lo si guarda. 

### Dinamico! Non interattivo!

Sul web si trovano molte definizioni, La più semplice è sicuramente quella che definisce un sito dinamico come "interattivo per l'utente". OK... Allora sulla base di questo possiamo tranquillamente considerare anche [questo](http://info.cern.ch/hypertext/WWW/TheProject.html) come dinamico? Dopotutto ci sono davvero un sacco di link da cliccare, potete passarci tutto il finesettimana, davvero!

![that's enough internet](/images/enough_internet.jpg)

Osserviamo il problema da un altro punto di vista; questa è una delle [riposte](https://www.quora.com/What-are-examples-of-a-dynamic-website/answer/Justin-Rashidi) che si trovano su Quora:

>The main differences between a static and dynamic website is that with dynamic websites allow interaction while static websites all the information needs to be updated by an admin.

Non molto utile questa prima parte... Questo passaggio però ci viene più in aiuto:

> From a technical standpoint a dynamic website needs to have a server side language like python, ruby, php, etc and a database system that stores the dynamic information.

OK! Questo è già più utile per la distinzione che voglio fare osservando il problema dal punto di vista del **momento in cui vengono assemblati i contenuti da servire all'utente**.

### Come avviene la generazione dei contenuti

Guardando il problema da questa prospettiva, si può definire dinamico il sito che "renderizza" i contenuti solo una volta ricevuta una richiesta da parte dell'utente.

Semplificando al massimo,questi sono 5 possibili step dello scenario tipico:

1. ricezione della richiesta dall'utente (tipicamente tramite browser)
2. acquisizione degli asset (pagine HTML, immagini, codice PHP/Ruby/Java...)
3. esecuzione del codice acquisito
4. caricamento dei dati da database
5. restituzione all'utente della pagina testè assemblata

![sito dinamico](/images/dynamic_site.gif)

Questo scenario è spesso associato allo stack LAMP (Linux - Apache - MySQL - PHP) e, più in generale, ad architetture composte da un server WEB, un database ed un linguaggio di programmazione con cui eseguire delle operazioni.

Con questo sistema si possono servire contenuti altamente personalizzati ed interattivi come ad esempio:

* Commenti
* UI personalizzata secondo preferenze
* CMS (Content Management System)
* Meteo 
* Ricerche

### Davvero molto bello, ma...

Ovviamente tutte queste cose belle non sono gratis: provate ad immaginare di andare al ristorante ed ordinare un risotto; la cottura del riso richiede tempo e dovrete attendere un po' prima che vi sia servito il piatto. 

Lo stesso ragionamento si applica in questo caso, poichè assemblare i contenuti richiede tempo. Ma all'utente che (leggere con forte accento milanese) *non ha mica tempo da perdere*, non piace attendere, giusto?

Un altro punto da non sottovalutare, è che, più elementi abbiamo nell'architettura e più diventa complicato gestirli. Qualcuno di voi ha mai dedicato del tempo all'ottimizzazione di siti Wordpress? Si comincia con il rimuovere qualche plugin superfluo per poi trovarsi a sguazzare in **caching** e compressione degli asset, **cache**  delle query, supponendo ovviamente che qualcosa nel mezzo non si rompa.



Resta intesto che ci sono scenari in cui programmare un sito secondo questo paradigma è l'unica strada percorribile, come ad esempio:

* un sito di prenotazione di voli/hotel/treni
* un gestionale
* una webapp (perchè usare qualche buzzword ogni tanto fa sempre bene)

Ma... vale lo stesso per un blog? Secondo me no; almeno non per un blog personale.


## Siti statici

Per chi pensava di essersela cavata, la strada è ancora lunga perchè ora facciamo un tuffo nel passato.



Chiudo l'articolo con una piccola provocazione: renderizzare i contenuti tramite client-side scripting è da considerarsi dinamico?

![sito statico](/images/static_site.gif)