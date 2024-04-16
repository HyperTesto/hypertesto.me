---
authors:
- hypertesto
categories:
- articolo
cover: /images/lubuntu.jpg
date: "2020-06-01T22:00:00Z"
tags:
- linux
- lubuntu
title: Le mie prime impressioni su Lubuntu 20.04
---
Recentemente ho installato Lubuntu sul mio laptop **HP 255 G7**[^0] e volevo lasciare due note visto che la mia prima e unica esperienza con LXDE risale a 8 anni fa.

Era da un po' che volevo provare a muovermi dal mio SO di riferimento che è Mint MATE, ho deciso quindi di provare a usare Lubuntu. Capiamoci: non era indispensabile installare qualcosa di così _light,_ tuttavia la tattica che ho adottato è installare sempre qualcosa che uso in modo da essere efficiente se mi capita di dover dare assistenza.

## Installazione

L'installazione è filata liscia, Calamares, seppur con qualche lieve differenza, è sempre il solito installer che siamo abituati a usare su Ubuntu.

Non funzionava la wireless perciò sono dovuto ricorrere al buon vecchio cavetto ethernet per installare anche i pacchetti di lingua, driver e compagnia bella. (Il problema comunque non è la distro, seguirà un breve articolo su come sanare la situazione)

## Utilizzo

Funziona. Tutto è al suo posto ed è magnificamente consistente. Sono rimasto davvero impressionato dalla qualità del lavoro svolto dai team di LXQt e di Ubuntu.

Mi mancano alcune feature più avanzate che avevo in Cinnamon e MATE, ma per l'uso che faccio di questo PC, ovvero navigazione e un po' di videoscrittura, non mi fascio la testa.

La batteria sta durando svariate ore: almeno 3 con Firefox aperto con due o tre tab, telegram in background e schermo con luminosità al massimo.

## Temi e gigiate varie

Per la prima volta nella mia vita, **non ho messo mano al tema.** È scuro al punto giusto e non sento la necessità di passare a una variante più scura ancora; cosa che invece faccio sempre su MATE.

Le icone mi piacciono, e anche la variante azzurra è una piacevole differenza rispetto al verde Mint.

Il pannello inferiore è ben organizzato: nulla di troppo diverso da quello di altri DE. Invece mi piace molto che di default siano presenti QClipper e lo storico delle notifiche; non rompono e sono davvero molto utili in parecchie occasioni.

Unica nota circa il pannello inferiore, è che è estremamente facile romperlo (un po' come succede in quello di MATE). Per questo punto ho un paio di note su come fare a ripristinare quello di default che condividerò in un prossimo articolo.

Il DE è stato portato da `GTK+ 2` (GNOME) alle `QT` (KDE), infatti il nome del progetto è diventato `LXQt` . Non sono mai stato un fan delle librerie Qt: i programmi fatti con esse mi sono sempre sembrati più "giocosi" e meno professionali rispetto a quelli fatti in GTK. Qui non ho avuto questa percezione, tutto è molto curato è dal look pulito e moderno.

Infine... Lo screensaver attivo di default è **meraviglioso**.

## Software

Trattandosi di Ubuntu, il software preinstallato è adeguato. Se manca qualcosa, si fa presto a installare.

Vorrei comunque spendere qualche parola sui software con cui interagisco maggiormente.

### L'applet del network manager

All'inizio è stato un trauma: dal menù a tendina non trovavo nulla per gestire i vari profili di connessione. Invece ho scoperto che sono tutti presenti e raggiungibili con click del tasto destro del mouse! Secondo me come scelta è in controtendenza rispetto agli altri, ma in fin dei conti aiuta a mantenere un minimo di ordine (potrei anche farci l'abitudine).

Comunque... Il verdetto è che mi fa cagare un po' meno di quello di MATE ma di più di quello di Cinnamon.

Al momento non ho ancora trovato un applet che mi piaccia veramente: infatti mi ritrovo spesso a taroccare reti direttamente da terminale.

### FeatherPad

![](/images/editor.jpg "featherpad")

Ha tutto quello che mi aspetto da un editor base:

* Sottolineatura della sintassi
* Visualizzazione del numero di riga sulla sinistra
* Indentazione del testo multiriga
* Uno spellchecker (utile se si scrive documentazione in markdown)
* La status bar con la posizione attuale del cursore

Trovo invece meno pratico e più limitato il trova e sostituisci rispetto ad esempio a quello presente in _xed_. Questo in realtà è un non-problema dato che nell'uso che ne sto facendo non vado spesso di `CTRL-F` o `CRTL-R.`

Promosso comunque a pieni voti.

### PCManFM-QT

![](/images/pcmanfm.jpg)

Anche in questo caso non ho riscontrato mancanze, di fatto le cose che mi servono sono:

* la vista divisa
* il _"connetti al server"_
* i segnalibri
* editare i path al volo direttamente nella relativa barra
* smontare i volumi
* aprire un terminale
* aprire un terminale come root

Riguardo questi ultimi due punti ci sono un paio di dettagli che secondo me avrebbero fatto una gran differenza:

* nel menù contestuale generato dal click destro in un'area vuota manca la possibilità di aprire un terminale (come root o non).
* dal menù contestuale generato al click destro su una cartella, è presente solo la possibilità di aprire un terminale come utente normale.

Carino invece che venga sempre mostrato lo spazio disponibile del volume corrente nella barra di stato in basso. Se fosse possibile avere un piccolo indicatore con l'occupazione sotto al nome di ogni volume (come in Nemo) sarebbe il top del sogno.

Se dovessi utilizzare questo PC per scopi lavorativi, l'unica cosa che mi mancherebbe sul serio è una vista ad albero per navigare nelle sottocartelle senza dovermi spostare da quella corrente (la cosa mi torna comoda soprattutto in split view).

### QTerminal

![](/images/terminal.jpg)

Fa quello che deve egregiamente, tra l'altro ho apprezzato particolarmente la paletta di colori presente di default... Lo sfondo senza trasparenza per me è imprescindibile, e non capisco come tanta gente riesca a lavorare con lo sfondo trasparente... Chissà.

Bello che ci sia nativamente la possibilità di splittare il terminale verticalmente e orizzontalmente. Non tutti gli emulatori di terminale presenti tra le applicazioni di default dei vari SO hanno questa caratteristica.

Rispetto a Tilix, mi manca un modo comodo per muovermi tra le varie tab, ma anche in questo caso non è una cosa bloccante per l'utilizzo che faccio di questa installazione.

### Screen Grab

![](/images/screen_grab.jpg)

Questa è forse l'applicazione con cui mi sto trovando meno... Ho dovuto smanettare per una buona decina di minuti prima di capire bene come funziona:

* L'applicazione alle volte si apre presentando già uno screenshot basato sulle impostazioni dell'ultimo effettuato.
* La combinazione `ALT-STAMP` non è configurata (questo però potrebbe avere a che vedere con il fatto che la tastiera è tedesca e io la sto usando come una italiana senza tasti morti)
* Il path di salvataggio di default non è nella cartella "Immagini"
* Il nome del file generato non contiene il timestamp

Per questi ultimi due punti basta cambiare un paio di preferenze. Per il resto penso che dovrò sperimentare ancora un pochino, soprattutto con gli shortcut personalizzati.

## Verdetto

Erano anni che non provavo qualcosa di diverso da Mint. La combo Ubuntu 20.04 + LXQt mi ha lasciato impressionato per la qualità e la stabilità del sistema nel suo complesso.

Non è assolutamente è una distro da usare solo su computer datati, anzi, personalmente penso che la installerò anche su un paio di macchine ben carrozzate che ho a casa!

Era un po' che non scrivevo nulla sul blog, ma ho già un altro paio di brevi guide in canna, penso di pubblicarle nei prossimi giorni.

Egregi signori, alla prossima!

[^0]: L'ho trovato lo scorso anno in occasione su eBay. Con meno di 300€ mi sono portato a casa un portatile con un bel Ryzen, SSD e schermo Full HD.
