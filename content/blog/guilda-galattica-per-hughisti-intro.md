---
title: "Guida Galattica per hughisti: Introduzione"
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

Miei cari autostoppisti del web, allacciate le cinture, stiamo per partire!

## Siti dinamici

Cominciamo subito col dire che questa distinzione è puramente arbitraria, in quanto, come spesso succede nel mondo dell'informatica, il problema cambia molto a seconda di come lo si guarda.

Questa è una delle [riposte](https://www.quora.com/What-are-examples-of-a-dynamic-website/answer/Justin-Rashidi) che si trovano su Quora:

>The main differences between a static and dynamic website is that with dynamic websites allow interaction while static websites all the information needs to be updated by an admin.

Non molto utile questa prima parte... Questo passaggio però ci viene più in aiuto:

> From a technical standpoint a dynamic website needs to have a server side language like python, ruby, php, etc and a database system that stores the dynamic information.

OK! Questo è già più utile per la distinzione che voglio fare guardando il problema dal punto di vista del **momento in cui vengono assemblati i contenuti da servire all'utente**.

Guardando il problema da questa prospettiva, si può definire dinamico il sito che "renderizza" i contenuti server side solo una volta ricevita una richiesta da parte dell'utente.

![sito dinamico](/images/dynamic_site.gif)

Ho provato a riassumere tutto, semplificando al massimo, ricavando sostanzialmente 5 step dello scenario tipico:

1. ricezione della richiesta dall'utente (tipicamente tramite browser)
2. acquisizione degli asset (pagine HTML, immagini, codice PHP/Ruby/Java...)
3. esecuzione del codice acquisito
4. caricamento dei dati da database
5. restituzione all'utente della pagina testè assemblata

Con questo sitema si possono servire contenuti altamente personalizzati ed interattivi come ad esempio:

* Commenti
* UI personalizzata secondo preferenze
* CMS (Content Management System)
* meteo live

Ovviamente tutte queste cose belle non sono gratis: provate ad immaginare di andare al ristorante ed ordinare un risotto; la cottura del riso richiede tempo e dovrete attendere un po' prima che vi sia servito il piatto. 

Lo stesso ragionamento si applica in questo caso, poichè assemblare i contenuti richiede tempo. Ma all'utente che (leggere con forte accento milanese) *non ha mica tempo da perdere*, non piace attendere, giusto?





Per chi è più malizioso lancio una provocazione: renderizzare i contenuti tramite client-side scripting è da considerarsi dinamico?

## Siti statici


![sito statico](/images/static_site.gif)