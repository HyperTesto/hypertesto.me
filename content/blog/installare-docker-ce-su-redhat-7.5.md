---
title: "Installare Docker CE Su Redhat 7.5"
date: 2018-07-04T16:53:03+02:00
draft: false
authors: ["hypertesto"]
categories:
  - guida
tags:
  - RHEL7
  - docker
---

Oggi ho battagliato un po' per installare Docker Community Edition su Redhat 7.5 non essendo ancora ufficialmente supportato.

Questi sono gli step che ho dovuto seguire:

* Installare yum-utils ed epel-release:


```bash
# yum install -y yum-utils
# wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
# rpm -ivh epel-release-latest-7.noarch.rpm
```

* Aggiungere il repo di docker-ce al sistema:

```bash
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

* Installare container-selinux (altrimenti l'installazione non prosegue per mancanza della dipendenza):

```bash
# yum install -i http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.55-1.el7.noarch.rpm
```

**Nota:** se il pacchetto non viene trovato vi basta rimpiazzare la versione con un'altra che si trova sempre nello stesso mirror

* Installare Docker CE:

```bash
# yum install -y docker-ce
```

* Avvio ed attivazione del servizio

```bash
# systemctl start docker
# systemctl enable docker
```

Per le verifiche ed il post-installazione vi rimando alla [documentazione ufficiale](https://docs.docker.com/install/linux/linux-postinstall/).

Alla prossima!
