---
authors:
- hypertesto
categories:
- guida
date: "2018-09-12T22:13:31+02:00"
draft: false
tags:
- git
- gogs
- server
title: Hostare repo Git privati con Gitea
---

Negli anni ho accumulato un sacco di sorgenti tra codice Java, Bash e altri linguaggi (addirittura il [Moonscript](https://moonscript.org/) di cui non ricordavo nemmeno l'esistenza), prima di perderli accidentalmente ho deciso di caricarli su un server Git privato.

Ci sono un sacco di opzioni per server git "self-hosted", tra tutte io ho scelto [Gitea](https://gitea.io/en-us/) perchè oltre ad essere leggerissimo è davvero facile da installare e da gestire successivamente. Gitea è nato come fork di [Gogs](https://gogs.io/) ed è attivamente sviluppato e manutenuto da una comunità molto vivace.

Dal punto di vista tecnico, Gogs è scritto in [Go](https://golang.org/) ed è distribuito con un file semplice file binario quindi l'installazione è davvero un processo semplice.

Per scelta personale ho preferito installarlo con un container docker e metterlo dietro ad un reverse proxy per gestire la terminazione SSL. Utilizzando questi tool la distro Linux che utilizzate è piuttosto indifferente.

Nell'immagine vedete l'architettura di massima della soluzione proposta:

![architettura Gitea](/images/gitea.png)

Passiamo all'azione.

## Prerequisiti

* Un server Linux raggiungibile da internet
* Docker installato sul sistema
* Nginx installato sul sistema
* Certbot installato sul sistema
* Un nome a dominio valido che punti al server


## Installazione e avvio con docker

Creare un file `gitea-compose.yml` con il seguente contenuto:

```Bash
version: "2"

networks:
  gitea:
    external: false

volumes:
  gitea:
    driver: local

services:
  server:
    image: gitea/gitea:latest
    restart: always
    networks:
      - gitea
    volumes:
      - gitea:/data
    ports:
      - "3000:3000"
      - "222:22"
```

Questa configurazione è piuttosto semplice:

* il container gira su una rete dedicata
* viene montato un volume locale in modo che i dati siano persistenti anche in caso di riavvio
* Sono esposte la porta 3000 e la 22 (quest'ultima è pubblicata sulla 222)
* la polici "restart : always" fa in modo che il container sia avviato in automatico e che venga riavviato in caso di errore

Per creare il container digitare il comando:

 ```Bash
 # docker-compose -f gitea-compose.yml up -d
 ```

Per verificarne il corretto avvio basta dare un `docker ps` che dovrebbe ritornare un output simile:

```Bash
# docker ps
CONTAINER ID        IMAGE                COMMAND                  CREATED             STATUS              PORTS                                         NAMES
cb2104245aff        gitea/gitea:latest   "/usr/bin/entrypoint…"   2 weeks ago         Up 2 weeks          0.0.0.0:3000->3000/tcp, 0.0.0.0:222->22/tcp   gogs_server_1
```

## Configurazione del reverse proxy

Sebbene il server Gogs sia già raggiungibile in HTTP sulla porta 3000, ho deciso di aggiungere un piccolo livello extra di sicurezza facendo in modo che il server sia contattabile solo tramite HTTPS.

Per fare ciò occorre un nome a dominio valido che punti all'IP del server dove sta girando Gitea: nel mio caso il dominio è *git.hypertesto.me* e l'IP è *163.172.161.46*, potete anche verificarlo con `dig`:

```Bash
# dig git.hypertesto.me

; <<>> DiG 9.11.3-1ubuntu1.1-Ubuntu <<>> git.hypertesto.me
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 56013
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;git.hypertesto.me.		IN	A

;; ANSWER SECTION:
git.hypertesto.me.	1200	IN	A	163.172.161.46

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Wed Sep 12 23:06:31 CEST 2018
;; MSG SIZE  rcvd: 62
```

Per prima cosa occorre creare il file di configurazione di NGINX con il seguente contenuto, avendo cura di cambiare il mio nome a dominio con il vostro:

```bash
server {
        server_name git.hypertesto.me;

        location / {
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header Host $host;
                proxy_pass http://127.0.0.1:3000;
        }
```

Il file va salvato in `/etc/nginx/sites-available` e il nome è indifferente, nel mio caso ho scelto `git.hypertesto.me.conf`. Successivamente va creato un lìnk simbolico per abilitare il sito:

```bash
ln -s /etc/nginx/sites-available/git.hypertesto.me /etc/nginx/sites-enabled/
```

Infine per abilitare l'SSL con certbot basta digitare:

```bash
certbot --nginx -d git.hypertesto.me
```

Se tutta la procedura per ottenere il certificato va a buon fine otterrete questa videata:
```bash
Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
-------------------------------------------------------------------------------
1: No redirect - Make no further changes to the webserver configuration.
2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
new sites, or if you're confident your site works on HTTPS. You can undo this
change by editing your web server's configuration.
-------------------------------------------------------------------------------
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):
```

Consiglio di scegliere sempre la seconda opzione in modo da redirezionare in automatico tutto il traffico non HTTP verso HTTPS.

Il nuovo contenuto del file di configurazione sarà il seguente:

```bash
server {
	server_name git.hypertesto.me;

	location / {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $remote_addr;
		proxy_set_header Host $host;
		proxy_pass http://127.0.0.1:3000;
	}
 # managed by Certbot

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/git.hypertesto.me/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/git.hypertesto.me/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = git.hypertesto.me) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


	server_name git.hypertesto.me;
    listen 80;
    return 404; # managed by Certbot


}
```

Ora potete collegarvi al vostro nuovo server Gitea e terminare la configurazione guidata.

Per questa volta è tutto, se avete dubbi non esitate a lasciarmi un commento.

**PS**: se vi state chiedendo dove sono i file sul filesystem (magari per farci un **backup**), basta controllarlo con un comando di inspect:

```bash
# docker volume inspect gogs_gitea
[
    {
        "CreatedAt": "2018-08-29T20:41:28Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/gogs_gitea/_data",
        "Name": "gogs_gitea",
        "Options": null,
        "Scope": "local"
    }
]

```
