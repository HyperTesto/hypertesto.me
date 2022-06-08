---
title: "Ho cambiato distro e sono sopravvissuto per poterlo raccontare"
date: 2022-06-07T19:19:08+02:00
draft: false
categories:
  - articolo
tags:
  - distro
  - fedora
---
Non sono mai stato una persona che ama i cambiamenti, men che meno se si tratta di qualcosa come un S.O. che uso quotidianamente anche per lavoro.
Questa volta però, un po' per _una serie di sfortunati eventi_[^0], un po' per volontà di apportare dei cambiamenti al mio modo di lavorare, la transizione
è riuscita con successo!

{{< alert >}}
<details>
  <summary>TL;DR per i pigri</summary>
  1. Sono passato a Fedora e funziona meravigliosamente bene.  
  2. Commentate!
  </details>
A tutti gli altri buona lettura! :wink:
{{< /alert >}}

## Chi è causa del suo mal

{{< figure
    src="img/articles/paolo_bitta_meme.jpg"
    alt="È causa del suo mal"
    caption="I proverbi di Paolo Bitta, l'uomo chiamato contratto"
    >}}

Sono un maledetto **feticista dei default**, così tanto da non cambiare nemmeno lo sfondo... Questa affermazione potrebbe suonare un pochettino male, perciò meglio motivarla per bene!

Nel tempo (ormai una decina d'anni) ho maturato la ferma convinzione che le distro Linux vadano usate "di fabbrica"; ovvero senza
taroccare troppo il sistema.  
I motivi sono essenzialmente tre:

- I default, nell'ambito di un S.O., sono un insieme di programmi e relative configurazioni che sono mantenuti da una community, perciò ragionevolmente stabili e testati
- Se qualcosa non funziona è molto meno complicato ottenere supporto visto che un default è di per se uno scenario ragionevolmente riproducibile
- Di norma i default sono pensati da gente _**che ne sa**_ molto di più di me o dei soliti crociati da tastiera che credono di saperne sempre una in più degli stessi sviluppatori

E poi c'è il motivo bonus del tutto personale:

- L'idea di personalizzarmi un S.O. nel minimo dettaglio mi piace... ma può funzionare solo nella mia testa!  
  Nella pratica la mia pigrizia ha sempre il sopravvento e finisco sempre col preferire qualcosa di stabile 
e sufficientemente vicino al mio modo di lavorare[^1].

Questo mio modo di pensare mi ha avvicinato a Linux Mint che all'epoca (si parla di 7-8 anni fa) era davvero spanne al di sopra di Ubuntu per quel che riguardava "le minuzie". 
Era tutto stabile e meravigliosamente curato nei minimi particolari (almeno quelli che mi interessavano più da vicino).

E così arriviamo a fine 2021 con la mia fedele Mint MATE che, con il suo _GNOME2 vibes_, ancora mi serviva egregiamente bene... o quasi.

## La nemesi

Negli ultimo paio d'anni ho avuto un progressivo cambiamento nel modo in cui utilizzo il PC:

- Con lo smartworking il PC fisso che ho a casa è diventato la mia macchina principale di lavoro
- Con i lockdown ho ricominciato un po' a giocare
- Con la stessa scusa ho provato a fare anche un po' di stream su Twitch

Gira che ti rigira, i miei carissimi default sono totalmente andati a farsi benedire: 
- prima ho cominciato ad usare un kernel più recente, poi uno custom per il supporto ai [futex](https://man7.org/linux/man-pages/man2/futex.2.html),
- poi MATE non aveva il supporto al [pixel perfect scaling](https://tanalin.com/en/articles/integer-scaling/) (per giocare a giochi _vecchi_ a schermo intero o a risoluzioni umane) e quindi ho usato un mezzo accrocchio,
- infine, per incasinarmi ulteriormente la vita, ho sostituito il server audio Pulse con [PipeWire](https://pipewire.org/)[^3] che mi serviva per avere un routing audio decente dentro a OBS: se avete il tarlo per avere l'audio delle varie applicazioni e il microfono tutti su input separati potete capirmi.

Insomma, nel mio sistema si era accumulato un bel casino, ma soprattutto aveva cominciato a dare segni di cedimento con qualche sporadico crash.

E così si torna a fine 2021, con me incollato davanti al PC senza aver fatto ferie[^4], ma con la mia Mint che fa ancora il suo dovere anche non sento più particolarmente mia.  
Poi, con l'anno nuovo ed un tempismo che definirei mefistofelico, Virtualbox  ha cominciato a rompersi ad ogni aggiornamento... prima il kernel più recente non è supportato e faccio il downgrade, poi lo patchano ma rompono la compatibilità con le versioni precedenti.  

Se non mi fosse servito più di tanto avrei anche sorvolato, ma quando ti succede mentre devi  chiudere dei progetti in fretta e furia, gli zebedei ti girano.

{{< figure
    src="img/articles/mosconi.jpg"
    alt="Germano Mosconi"
    caption="Germano Mosconi, la caption è superflua. Immagina, puoi."
    >}}

La successiva escalation di eventi nella quale ho tentato vari approcci per sistemare VirtualBox, mi ha portato ad avere l'installazione completamente non avviabile. Insomma, _peggio la toppa del buco_.

## Il nuovo inizio[^5]
Era già da un po' che tenevo d'occhio Fedora e mi frullava in testa l'idea di passare ad una distro _rpm-based_ per avere maggior uniformità con le RHEL / CentOS che uso al lavoro. Così mi sono
buttato con una bella formattazione completa[^6] e la successiva installazione di Fedora 35.

Fedora si è rivelata una distro molto più nelle mie corde di quanto pensassi, inoltre copre già di suo, senza andare a toccare nulla, la maggioranza dei miei casi d'uso emersi di recente:

- È una distro [upstream first](https://docs.fedoraproject.org/en-US/package-maintainers/Staying_Close_to_Upstream_Projects/), ovvero cerca nei limiti del possibile di usare software così come viene fornito da chi lo sviluppa, senza applicare patch o personalizzazioni. Questo porta con se dei vantaggi non da poco:
  1. Gli aggiornamenti arrivano con maggior rapidità e frequenza
  2. Se ci sono problemi con il software  facile ottenere supporto direttamente dalla fonte (ricordatevi che non sempre chi _pacchettizza_ un software ha lo stesso livello di conoscenza di chi lo sviluppa, anzi nel caso
  estremo potrebbe non essere nemmeno programmatore!)
  3. Se ci sono delle patch prodotte dalla community, vengono applicate al progetto upstream, quindi ne beneficiano tutti quanti sia che siano utenti di altre distro o potenzialmente anche di Windows o Mac  

  Nel mio caso la frequenza di aggiornamento si traduce nel poter usare un kernel recente e poter quindi giocare a ~~tante belle cose~~ Star Citizen tramite Wine.

- Con la versione 35 Fedora ha adottato PipeWire come server audio di default.  
  Questo copre anche il caso d'uso che è emerso con l'utilizzo che faccio di OBS (ed è anche _leggermente_ più stabile di quello che avevo accrocchiato su Mint)
- Utilizza Wayland di default[^7], che è un'altra cosa che era da tempo che volevo provare su strada

Ci sono tutta un'altra serie di sciccherie come ad esempio il supporto di prim'ordine a Flatpak, oppure la gestione degli aggiornamenti con quelli di sistema applicati al riavvio. Insomma, cose da dire ce ne sarebbero, ma mi dilungherei troppo non trattandosi di una recensione. Per ora mi limito a dire che è una distro dannatamente solida e, lasciatemi dire, sto apprezzando davvero molto il lavoro svolto da RedHat nell'ecosistema Linux[^8].

## Considerazioni su Gnome
Con Gnome 2 mi sentivo a casa, quando è uscita la 3 è stato un disastro totale. Ricordo di aver provato più volte a fare il salto di versione e, _boia l'orso_, avrei voluto capire sulla base di cosa avessero letteralmente
tolto funzionalità utili che se c'erano nella versione 2 ci sarà stato un motivo! Non immaginate il trauma di non avere nel menù contestuale la possibilità di aprire un terminale nel percorso corrente. 

Comunque con Gnome 41 devo umilmente riconoscere che hanno fatto un lavorone, hanno sicuramente saputo intervenire e fare anche dei passi indietro laddove c'era oggettivamente il bisogno. Il DE è solidissimo, moderno ed
essenziale. Trovo comunque scomodo il fatto di dover passare per degli addon per fare cose che riterrei o doverci essere di base (le icone nella tray, maledizione!) o comunque essere presenti tra le impostazioni di sistema.

Comunque,  dovesse servire a qualcuno queste sono le estensioni che uso io:

{{< figure
    src="img/articles/gnome_extension.png"
    alt="Le estensioni che uso su Gnome"
    caption="Le estensioni che uso su Gnome"
    >}}

- AppIndicator e KBlaBlaBla Support: per mostrare le iconcine nella shell (Se usate Skype, ad esempio)
- Places Status Indicator: come si capirà sicuramente dal nome, aggiunge un menù dal quale aprire rapidamente le cartelle principali

## E VirtualBox?

L'ho mandato a quel paese! Togliendolo dall'equazione dormo decisamente sonni molto più tranquilli.  
Non potendo comunque fare a meno di usare le VM, sto utilizzando con molta soddisfazione [Gnome Boxes](https://wiki.gnome.org/Apps/Boxes), ma su questo avrò modo di scrivere spero presto.

{{< figure
    src="img/articles/virtualbox_meme.jpg"
    alt="VirtualBox, non mi mancherai"
    caption="VirtualBox, non mi mancherai"
    >}}

Ci legge spero presto adesso che ho ripreso a scrivere sul blog!

{{< alert >}}
Ci sono anche i commenti, non fate i timidi, vi tengo d'occhio eh! :eyes:
{{< /alert >}}


[^0]: La cit. al [Film](https://it.wikipedia.org/wiki/Una_serie_di_sfortunati_eventi) era necessaria! 
[^1]: E poi non avete idea dei castroni che combino quando metto mano ai colori[^2]
[^2]: Sì, sono daltonico... e anche un po' scemo già di mio
[^3]: Ovviamente essendo Mint una distro basata su una LTS di una distro che notoriamente non brilla per rapidità nel recepire aggiornamenti o software novelli, poteva essere già supportato?  
[^4]: Esatto, quest'anno ero io il fortunello
[^5]: Senti come suona bene
[^6]: Ah già, ovviamente avevo i backup di tutto, altrimenti `#ciaone`
[^7]: Per ora non con NVIDIA per alcuni problemi con i suoi _fantastici_ driver
[^8]: Sì, lo so che la rivoluzione con CentOS Stream non è stata proprio ben vista da tutti, ma insomma 