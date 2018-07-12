---
title: "Moduli Git in pillole"
date: 2018-07-12T23:14:31+02:00
draft: false
categories:
  - appunti
tags:
  - git
---

I moduli di Git sono davvero comodi, tuttavia mi capita di usarli di rado... Infatti ogni volta non ricordo mai come devo fare :-)

Per aiutarmi ho stilato queste brevissime note:

* Aggiungere un nuovo modulo:

```bash
$ git submodule add ssh://il.mio.fichissimo.modulo cartella_modulo
$ git submodule init
```

* Aggiornamento con il remote e commit:

```bash
$ cd cartella_modulo
$ git pull

# dalla root del progetto
git add cartella_modulo
git commit -m "Aggiornamento modulo"
```

* Aggiornamento simultaneo:

```bash
git submodule foreach git pull origin master
```

Alla prossima!
