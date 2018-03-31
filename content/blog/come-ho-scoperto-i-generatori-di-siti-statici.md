---
title: Come ho scoperto i generatori di siti statici
date: 2017-11-22T21:28:54.616Z
categories:
  - appunti
tags:
  - config
  - bug
---
Il mio primo avvicinamento al mondo dei generatori di siti statici è nato sostanzialmente ~~dall'odio profondo~~ dall'antipatia che ho sviluppato per il PHP e all'ecosistema che gravita attorno ad esso:

1. Generalmente è lento da far spavento (anche se la 7 ha fatto miracoli sotto questo punto di vista)[1]
2. Lascia al programmatore una libertà incredibile per implementazioni bacate (ad esempio query costruite direttamente concatenando parametri di una form)
3. Molte funzioni della libreria standard sono caotiche e la documentazione spesso non è da meno (ah, a proposito vi sfido a capire cosa fa esattamente [questa](http://php.net/manual/en/function.similar-text.php) funzione)

Tornando al discorso originale, quando ho cominciato a "ravanare" con i siti WEB (principalmente blog), ho utilizzato un po' Joomla per poi passare a Wordpress, che è davvero un progretto fantastico e ben mantenuto, ma... c***o è pur sempre in PHP. Se parliamo di velocità in termini di semplicità di configurazione e tempo di apprendimento Wordpress è davvero un missile, però mannaggia a quella pagina che ci mette sempre una vita a caricare!

Comunque nulla di insormontabile con Wordpress: una cache qua, un plug-in là ed un po' di compressione e sito funziona che è una meraviglia. Con 50 plug-in ma comunque funzionante. 

Però si sa che la fortuna è cieca ma la sfiga le diottrie le ha ancora tutte... **BOOM!** Il sito si pianta. Nessun problema ci sono i back— cazzo i backup.

![backup questi sconosciuti](/images/uploads/dubt.png)

Forti dell'esperienza fatta, in qualche modo sistemiamo e, questa volta, applichiamo una policy di backup rigidissima, anche per il database.

Quindi ricapitolando:

1. il sito usa Wordpress
2. su Wordpress sono installati vari plug-in per rendere la velocità del sito accettabile
3. in qualche modo abbiamo messo in piedi una baracca per i backup dei file e del database

Ma... il committente, che supporremo senza mancare di generalità sia la "Pescheria da Tino", pubblica due articoli all'anno: gli auguri di Natale e quelli di Pasqua.

Davvero serve tutta questa manfrina per due miseri "articoli" all'anno?

Non bastava un po' di semplice HTML? Ipoteticamente sì, ma poi chi lo insegna l'HTML al signor Tino?

Cercando di trovare una risposta mi sono più volte imbattuto in articoli che parlavano di questi generatori di siti statici. In sostanza sono piuttosto semplici: si prepara un template, si aggiungono dei contenuti seguendo un determinato schema (aggiungendo file in alcune directory specifiche), si compila il tutto e via! Basta prendere sito così come è stato generato e caricarlo presso il nostro hoster preferito.

L'HTML ha sicuramente un grande pregio: non richiede nessuna interpretazione di codice lato server (salvo casi eccezionali), di conseguenza è molto veloce, soprattutto rispetto a PHP.

Ottimo: con una sola mossa ci siamo tolti di mezzo la necessità di ricorrere a plug-in o riti vodoo per velocizzare il caricamento dei contenuti. Rimangono solo quei maledetti backup.

Non avendo un database, ma avendo solo semplici file di testo, il meccanismo più semplice è mettere il sito sotto un sistema di controllo di versione, come ad esempio [Git](https://it.wikipedia.org/wiki/Git_(software)). In un colpo solo abbiamo i backup e anche un meccanismo che ci permette di fare rollback in caso qualcuno faccia danni.


Lasciando gli approfondimenti ad una serie di articoli che pubblicherò a breve, vi lascio una [comparativa](https://www.staticgen.com/) dei generatori di siti statici più utilizzati e [l'idea](https://jamstack.org/) attorno al quale sono stati sviluppati.

Rimanete sintonizzati!


[1]:https://hashnode.com/post/comparison-nodejs-php-c-go-python-and-ruby-cio352ydg000ym253frmfnt70
