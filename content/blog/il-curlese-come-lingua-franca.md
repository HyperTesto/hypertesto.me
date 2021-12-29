---
title: "Il curlese come lingua franca per gli addetti ai lavori"
date: 2021-12-28T22:34:17+01:00
draft: false
---
Nell'ultimo periodo mi capita spesso di essere al lavoro su progetti che richiedono
vari tipi di integrazioni con API di terze parti, quasi sempre HTTP(s).
Il problema è che ogni progetto ha una sua rete più o meno complessa, le porte sono
le più disparate, alcuni servizi usano SSL, altri ancora no e altri funzionano con rituali mistici.

Con queste premesse e con il fatto che c'è sempre da parlare con un sacco di persone diverse
di volta in volta, non è semplicemente possibile dire "con il mio *software*[^1] questa
chiamata non funziona per questi X motivi", anche fornendo a corredo dei log perfettamente chiari perchè:

* non è detto che gli interlocutori siano in grado e abbiano la voglia di interpretare i tuoi log
* è più facile assumere che sua tu il problema
* non si parla con la persona giusta

Ora, siccome i programmi che scrivo io sono **assolutamente infallibili**[^2] e quindi non
voglio dover anche dimostrare il loro corretto funzionamento ad altri, occorre un qualcosa di esterno
di conosciuto che anche gli interlocutori non possano metter in dubbio. Occorre
anche che questo qualcosa sia autodescrittivo, ovvero siano espliciti gli input che
vanno a riprodurre lo scenario di test e gli output che evidenzino le eventuali anomalie.

No, la risposta non è un bel vaffanculo indirizzato alle persone giuste... putroppo.

## Magico magico curl

In nostro soccorso arriva `curl`, un programma installato praticamente su qualsiasi distro (anche nei MAC, vero Apple?[^3])
con cui è possibile fare richieste http in qualsiasi salsa ed estrarre una marea di informazioni.

Non entro nel merito del funzionamento di tutti i possibili parametri, per quello c'è
il manuale da conoscere a menadito (vedetelo come una di quelle poesie che a scuola
facevano imparare a memoria, ma in versione informatichese).

Ma passiamo ad un esempio così da chiarire perchè `curl` è così figo:

![curl-esempio](/images/curl_esempio.png)

Come potete vedere c'è semplicemente tutto: input, output, negoziazione dei parametri,
messaggi scambiati "sotto il cofano" e c'è anche la possibilità di sbattere tutto in un
fantastico (a aggiungerei anche *scambiabile*) file di testo con una redirezione dell'output.

L'esempio che ho messo è piuttosto banale, perchè in questo scenario funziona tutto alla perfezione, ma come
ho detto nell'introduzione, l'utilizzo di curl come "lingua franca", torna estremamente utile
quando le cose NON funzionano come devono. In questi casi gli output attesi differiscono
a seconda di cosa non sta funzionando. Vi riassumo i casi che incontro più di frequente[^4]:

* Problemi di visibilità client-server: ```connection timed out```, ```connection refused```
* Problemi con certificati SSL autofirmati o firmati da CA non riconosciuta: ```SSL certificate problem: unable to get local issuer certificate```
* Problemi di handshake SSL[^5]: ```SSL routines:ssl3_read_bytes:sslv3 alert handshake failure```, ```curl: (35) Encountered end of file
```, ```Unable to establish SSL connection.```
* API che dovrebbero essere in HTTPS ma che invece sono ancora in chiaro: ```SSL routines:ssl3_get_record:wrong version number```


Se siete arrivati fin qui significa che il curlese interessa anche a voi, eccovi quindi
una panoramica rapidissima dei parametri utili ai fini di debug:

* `-v`, `--verbose`: visualizza messaggi HTTP (con header ecc) ed eventuale handshake SSL. Le linee che
cominciano con `>` sono i messaggi inviati, quelle che cominciano con `<` invece sono quelli ricevuti.
* `-k`, `--insecure`: salta la validazione del certificato SSL.
* `--connect-timeout <seconds>`: imposta un timeout di connessione, utile ad esempio se manca connettività
    e passa un era geologica prima di ricevere il due di picche (potreste anche interrompere con `ctrl-C`, ma noi
    studiosi del curlese vogliamo che qualsiasi eventuale risposta sia totalmente esplicitata nell'output)
* `--local-port <num/range>`: utilissimo per simulare un flusso tra due potre conosciute e censite su un firewall
* `-x`, `--proxy [protocol://]host[:port]`: utilizza un proxy per la richiesta
* `--trace-ascii <file>`, `--trace <file>`: abilita un dump di tutti i dati scambiati, la versione ascii è più human friendly
* `--trace-time`: aggiunge un timestamp ad ogni linea di dump/trace. Questo è utilissimo se dovete debuggare
fenomeni paranormali in cui dei messaggi arrivano con delay o cose simili. Di norma se
si è in uno scenario simile il buon senso vorrebbe che ci si doti anche di un `tcpdump` su
tutti i nodi interessati dallo scambio dei messaggi (server, client, firewall vari, ...), ma
putroppo non è sempre possibile disporne.

Bene, ora che siete adeguatamente *imparati* sull'argomento, non vi resta che diffondere
il verbo! Vi lascio qualche idea su come procedere per richiedere formalmente l'esecuzione
del comando:

* *Fammi un po' di curlate*
* *Curlami le API*
* *Curlami sto ca--volo di servizio*
* *Curlami tutto*

Ovviamente senza dimenticare il caso contrario:

* *Ho fatto qualche curlata qua e là*
* *Cuirlo cose, vedo gente*
* *I test di curlazione sono giunti al termine*

**Un'ultima nota prima di andare**: nell'immagine ho messo "negoziazione SSL" in modo un po' improprio
poichè in quell'output si vedono solo il certificato (nella parte di interesse per la validazione) e
i cifrari concordati. Di norma è comunque più che sufficiente, a patto di interloquire
con le persone giuste.

Se avete osservazioni o altri parametri utili ai fini di debug, la sezione commenti è tutta vostra!

[^1]: Baracca™
[^2]: Come me, del resto
[^3]: [VERO?!](https://twitter.com/AppleSupport/status/1461330383425970180)
[^4]: I messaggi possono variare molto anche in base alla versione di `curl`, quindi non prendeteli alla lettera, sono solo di esempio
[^5]: Qua si apre un bel calderone di possibilità: configurazioni lato server fatte male, cifrari vetusti non supportati da client moderni, e tante altre bellissime cose
