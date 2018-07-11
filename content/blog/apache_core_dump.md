---
title: "Come tracciare i core dump di Apache su RedHat 7.x"
date: 2018-06-18T21:39:05+02:00
draft: false
categories:
  - articolo
tags:
  - apache
  - debug
---

Prima o poi capita di trovarsi di fronte messaggi di errore poco amichevoli. È quello che mi è successo recentemente con Apache su una RedHat 7.4.

## Il problema

Il processo httpd crasha circa alle 3 di notte ogni 3 giorni con un bel messaggio:

```
seg fault or similar nasty error detected in the parent process
```

Il messaggio è davvero molto generico, ma con un po' di analisi ed un po' di aiuto sono riuscito a replicare il problema lanciando un graceful reload del servizio.  

Il fatto che il problema si presenta con una cadenza molto regolare in momenti in cui il sistema è palesemente scarico mi ha indirizzato verso qualche operazione schedulata. Infatti ho subito trovato conferma di questa ipotesi: su RHEL 7 la configurazione standard di Apache prevede l'esecuzione del logrotate esattamente con la cadenza con la quale si è verificata l'anomalia. Bingo!

## Generare i core dump

Ci sono vari modi per ottenere un core dump di un programma:

* strace
* gcore
* abrt
* altro

La soluzione più semplice che ho trovato è abilitare i dump con due configurazioni da fare alla unit e al file configurazione httpd.conf

* aggiungere `DAEMON_COREFILE_LIMIT=unlimited` al file `/etc/sysconfig/httpd`
* creare la cartella per il salvataggio dei dump:

```bash
mkdir -p /var/coredumps
chmod a+w /var/coredumps
```

* modificare il file `/proc/sys/kernel/core_pattern` per utilizzare la cartella appena creata:  


```bash
echo /var/coredumps/core-%e-%s-%u-%g-%p-%t > /proc/sys/kernel/core_pattern
```

* Specificare la cartella per il salvataggio dei dump nel file di configurazione di Apache `/etc/httpd/conf/httpd.conf` aggiungendo:


```bash
CoreDumpDirectory /var/coredumps
```

* riavviare Apache con `systemctl restart httpd`
* riprodurre il problema con `systemctl reload httpd`

Se la procedura è andata a buon fine dovremmo trovare il core dump nella cartella indicata in configurazione:

```bash
 ls -l /var/coredumps/
/var/coredumps/core-!usr!sbin!apach-11-0-0-3215-1485908109
```
## Analizzare il file generato

I core dump sono dei file binari, non è quindi possibile leggerli con un semplice editor di testo.
Per farlo occorre utilizzare strumenti specializzati, lo standard del mondo Linux è **gdb**.

In base al tipo di installazione effettuata (minimal, base, ...), potrebbe essere già installato, nel caso non lo sia già basta lanciare il comando `yum install gdb`.

Per lanciare l'analisi:

```bash
gdb httpd /var/coredumps/core-\!usr\!sbin\!apach-11-0-0-3215-1485908109
```

Infine, per visualizzare il trace, dalla console di gdb lanciare:

```bash
bt full
```

**Nota**: i dump possono occupare molto spazio, per cui è bene ricordarsi di rimuoverli una volta terminata l'analisi ;-)
