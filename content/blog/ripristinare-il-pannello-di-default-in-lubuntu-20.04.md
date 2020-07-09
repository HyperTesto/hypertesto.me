+++
cover = "/images/lubuntu.jpg"
date = 2020-06-07T10:00:00Z
title = "Ripristinare il pannello di default in Lubuntu 20.04"
authors = ["hypertesto"]
tags = ["linux", "lubuntu", "lxqt"]
categories = ["guide"]
+++
Come promesso nel precedente articolo, ecco una brevissima guida su come ripristinare il pannello di default in Lubuntu 20.04.

Quando si smanetta con i pannelli dei vari DE, capita spesso di incasinarli e fare disastri, nel mio caso specifico, ho inavvertitamente rimosso il pannello inferiore di LXQt.

Nel momento in cui scrivo non ho trovato soluzioni ufficiali su canali più mainstream: quelle presenti sono tutte piuttosto datate e non hanno funzionato sulla mia installazione fresca. Ad onor del vero potrebbe darsi che i miei termini di ricerca non fossero proprio corretti, infatti usavo "LXDE" invece di "LXQt".

Comunque, il ripristino si esegue con una semplice sovrascrittura/copia di un file di configurazione.

```bash
sudo cp /usr/share/lxqt/panel.conf ~/.config/lxqt/
```

Per rendere effettivo il ripristino, occorre riavviare o comunque iniziare una nuova sessione. Io per fare prima ho dato direttamente un bel `sudo reboot`.

Per questa volta è tutto, ci si legge prossimamente con un altra mini guida.
