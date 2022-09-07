---
authors:
- hypertesto
categories:
- articolo
date: "2018-06-19T23:58:27+02:00"
draft: false
tags:
- quarantena
- swag
title: Cookie, addio!
---

Come sicuramente saprete, alla fine di Maggio scadeva il termine per l'adeguamento alla normativa europea sulla privacy, la tanto temuta GDPR.
Questa normativa, fortunatamente, può essere vista come un framework con il quale chiunque tratta dati personali può fare un po' di sana "autocritica" riguardo ai dati "personali" che raccoglie e le modalità con cui essi vengono utilizzati. La vera figata è che non serve nemmeno ricorrere al giuridichese per "intortare" gli utenti, basta spiegare il motivo per il quale ogni dato viene raccolto, dimostrando che l'utilizzo che se ne fa è lecito.

## GDPR.tar.gz

In soldoni, la norma riconosce i seguenti diritti agli utenti:

* Il consenso alla raccolta e al trattamento da parte degli utenti dev'essere per esempio fornito in forma chiara (niente Azzecagarbugli di turno).
* Il consenso deve avvenire in maniera spacchettata per ogni trattamento effettuato e senza meccanismi di scelta "forzata" (ad esempio la checkbox già spuntata)
* I dati devono essere accessibili all'utente in qualsiasi momento in modo che li possa rettificare, modificare e possa approfondire l'utilizzo che ne viene fatto
* L'utente ha diritto alla portabilità dei dati da una piattaforma all'altra

Nella pratica, per i siti web e blog "semplici", la GDPR trova applicazione nella gestione dei cookie, aspetto che era già stato affrontato della vecchia "Cookie Law".

## Cookie

Un cookie, tradotto letteralmente con biscotto, in sostanza è un'informazione che viene immagazzinata (non sempre) dal nostro pc quando visitiamo un sito o una pagina web.
I cookie possono immagazzinare le informazioni più disparate: da un ID di sessione ad un elenco di pagine visitate.
La grossa distinzione fatta è la seguente:

* cookie tecnici
* cookie di profilazione

L'utilizzo dei cookie tecnici, è legato strettamente al funzionamento del servizio (mantenimento della sessione, di un carrello, ...), mentre quelli di profilazione sono utilizzati potenzialmente da molti altri siti che li utilizzano per tampinarci con pubblicità mirate oppure, per esempio, per effettuare operazioni di marketing automatiche tramite machine learning.

## Gotta erase 'em all

Facendo un po' di analisi e un po' di sana ricerca su DuckDuckGo (bè si Google ormai è da vecchi) ho isolato quali erano i cookie utilizzati dai miei siti e mi sono messo le mani nei capelli :-).
Quindi ho stilato questo elenco di buoni proposti:

* Niente servizi google (Analytics, Google Maps)
* Niente integrazione social
* Niente Disqus per i commenti

![gdpr](/images/gdpr.png)

Vi posso garantire che non solo dopo averli rimossi la Terra gira ancora, ma i siti si caricano anche più in fretta.  
Chiaramente esistono comunque soluzioni alternative e GDPR friendly; un buon punto di partenza è sicuramente [Awesome GDPR](https://github.com/erichard/awesome-gdpr) dalla quale ho già preso spunto per la sostituzione delle mappe Google.
