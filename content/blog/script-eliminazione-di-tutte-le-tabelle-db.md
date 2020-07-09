---
title: "Un semplice script per l'eliminazione di tutte le tabelle di un DB MySQL"
date: 2018-09-19T21:20:18+02:00
cover: /images/alt.jpg
draft: false
authors: ["hypertesto"]
categories:
  - snippet
  - appunti
tags:
  - database
  - MySQL
  - Bash
---
Ieri mi sono trovato nella situazione di dover ricreare un database poichè le tabelle ed i dati contenuti erano cambiati.

Creare tutti gli `ALTER` e `UPDATE` del caso era fuori discussione poichè si trattava di circa 2 milioni di record e non avevo tutti gli elementi per poter procedere.

La soluzione più facile è quella di importare un dump o uno script che effettua il `DROP` del database e la successiva creazione *from scratch* (perchè dirlo così suona più figo).

Il problema? Non avevo i permessi per poter ricreare il database.

L'unica soluzione rimanente consiste nell'eliminare tutte le tabelle contenute nel database. Facile, no? **NO!** Qualcuno si ricorda dei [vincoli di integrità referenziale](https://it.wikipedia.org/wiki/Vincolo_di_integrit%C3%A0_referenziale)? Bè io si... almeno dopo che ho lanciato il mio script ;-)

Il problema è che se sono definiti dei vincoli di integrità referenziale su una tabella e non sono definiti degli `ON DELETE CASCADE`, non è possibile eliminala. In soldoni se avete una relazione 1 a N tra la tabella A e la tabella B, non potete eliminare A se non eliminate prima B (per approfondire ecco un [video](https://www.youtube.com/watch?v=qOlhsLIc0lA)).

L'approccio più stupido per ovviare al problema è rilanciare la vostra sfilza di `DROP TABLE` finchè non avete più errori e di conseguenza avrete svuotato completamente il database. Ma ci sarà pure una soluzione più elegante!

{{< figure src="/images/lego_boy.jpg" caption="Una mia foto mentre sto per corrompere un DB di produzione" >}}


Spulciando la [documentazione](https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html) e facendo un po' di sano [*DuckDuckGaggio*](https://duckduckgo.com/), ho scoperto come disabilitare i check sui vincoli di integrità tramite il comando `SET foreign_key_checks = 0;
`.

Fortunatamente un'anima pia ha anche messo assieme un bello snippet pronto all'uso da lanciare con Bash che trovate su GitHub:

{{< gist cweinberger c3f2882f42db8bef9e605f094392468f >}}


L'unica cosa che manca allo script è il passaggio dell'host (nel caso l'istanza del DB non sia locale), ma è una cosa che si può facilmente aggiungere.

Se lo script vi è tornato utile non dimenticatevi di lasciare una star o un commento su [GitHub](https://gist.github.com/cweinberger/c3f2882f42db8bef9e605f094392468f#file-mysql-drop-all-tables-sh) al suo creatore!
