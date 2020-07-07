+++
cover = "/images/cables.jpg"
date = 2020-06-10T21:30:00Z
title = "Come far funzionare la wireless su un HP 255 G6 con Lubuntu 20.04"
authors = ["hypertesto"]

+++
Eccoci qui con un altra brevissima guida dedicata a Lubuntu 20.04 sul mio computer portatile HP 255 G6.

Breve storia triste: la scheda wireless non funziona con i driver caricati di default[^0].

Breve storia felice: il fix è facile, se avete dimestichezza con il terminale è questione di pochi minuti.

Qui di seguito sono riportati i passi da eseguire direttamente dal vostro utente di sistema:

```bash
$ sudo apt install git dkms build-essential
$ cd /tmp/
$ git clone https://github.com/tomaspinho/rtl8821ce.git
$ cd rtl8821ce/
$ sudo ./dkms-install.sh
```

A questo punto vi basterà riavviare per godere delle gioie che solo la vostra scheda wireless vi potrà dare 😜.

Il fix sul mio PC è stato totalmente risolutivo: non ho mai riscontrato instabilità o drop improvvisi della connessione.

Per questa volta è tutto, alla prossima!

[^0]: Consiglio: se dovete effettuare l'installazione del SO, munitevi di RJ-45, quello funziona sempre e non vi pianta sul più bello