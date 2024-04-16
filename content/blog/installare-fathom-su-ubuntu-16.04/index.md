---
authors:
- hypertesto
categories:
- guida
date: "2018-06-22T23:53:08+02:00"
draft: false
tags:
- gdpr
- statistiche
- fathom
title: Installare Fathom su Ubuntu 16.04
---

Fathom è un piccolo servizio opensource, sviluppato in Go, che fa una sola cosa e la fa bene: il tracciamento delle visite a un sito.
La raccolta di questo tipo dati non è una cosa da sottovalutare se si vuole essere conformi alla nuova normativa sulla privacy (e si ha un minimo di riguardo per i diritti degli utenti).

Fathom, anche e sopratutto grazie alla sua natura open, permette di raccogliere e analizzare le statistiche di un sito rispettando la privacy degli utenti, poiché non vengono né raccolti né memorizzati dati sensibili.

Poiché per il momento non è disponibile come saas, l'unico modo di poterlo utilizzare è installarlo da sè (probabilmente ce ne sarà una a pagamento in futuro).

In questo articolo vedremo come installarlo e configurarlo con un occhio di riguardo alla sicurezza. Per farlo sono necessari un server VPS o dedicato e un dominio valido.

## Architettura

Ci sono svariati modi in cui è possibile installare Fathom riportati sulla [documentazione ufficiale](https://github.com/usefathom/fathom/wiki/Installing-&-running-Fathom), quello che è veramente importante è esporre il servizio in HTTPS per garantire maggiore sicurezza e massima compatibilità con le policy di sicurezza dei browser (e visto che grazie a [Let's Encrypt](https://letsencrypt.org/) possiamo anche avere il certificato SSL gratis non ci sono scuse per non farlo).

![architettura del sistema](/images/fathom-arch.png)

L'architettura che andremo a implementare prevede:

* Nginx configurato come reverse proxye terminatore SSL
* Una o più istanze di Fathom in ascolto in locale
* MySQL / MariaDB

## Prerequisiti

Prima di partire assicuratevi di avere:

* Accesso root alla macchina
* Nginx installato e funzionante
* MySQL / MariaBD installato e funzionante
* Un dominio valido con un puntamento al vostro server
* Certbot installato e funzionante

### Configurazione del database

Collegarsi al server SQL e creare utente e database con i seguenti comandi:

```sql
mysql> CREATE DATABASE fathom_db;
mysql> CREATE USER 'fathom' IDENTIFIED BY 'MyStrongPassword';
mysql> GRANT ALL privileges ON fathom_db.* TO 'fathom'@localhost;
mysql> FLUSH PRIVILEGES;
mysql> exit;
```

**Importante:** ricordatevi di cambiare la password con una a vostra scelta

Per controllare che il tutto sia andato a buon fine potete ricollegarvi al database con l'utente appena creato:

```bash
$ mysql -u fathom -p fathom_db
```

Le tabelle verranno create in automatico al primo avvio del servizio.

## Installazione e avvio del servizio

Fathom viene distribuito tramite un comodo binario precompilato che possiamo installare come comando disponibile a tutti gli utenti.

```bash
$ wget https://github.com/usefathom/fathom/releases/download/latest/fathom-linux-amd64
$ mv fathom-linux-amd64 /usr/local/bin/fathom
$ chmod +x /usr/local/bin/fathom
```

Per testare il comando potete semplicemente controllare se ottenete l'output del lancio dell'help:

```bash
$ fathom --version
Fathom version 1.0.0
```

Per fare le cose per bene andremo a configurare un utente ad-hoc:

```bash
$ useradd fathom
```

Nella home dell'utente fathom (`/home/fathom/`) creare il file di configurazione `.env` con il seguente contenuto:

```bash
FATHOM_SERVER_ADDR=9000
FATHOM_DEBUG=false
FATHOM_DATABASE_DRIVER="mysql"
FATHOM_DATABASE_NAME="fathom_db"
FATHOM_DATABASE_USER="fathom"
FATHOM_DATABASE_PASSWORD="MyVeryStrongPassword"
FATHOM_DATABASE_HOST="localhost"
FATHOM_SECRET="random-secret-string"
```

Abbiate cura di cambiare `random-secret-string` con una strina a piacere (viene utilizzata per firmare i cookie di sessione da buona prassi si sicurezza).

Avendo creato il file da utente root è necessario cambiarne il proprietario:

```bash
$ chown fathom:fathom /home/fathom/.env
```

Ora che il tutto è pronto è possibile fare un primo test di avvio del servizio:

```bash
$ cd /home/fathom
$ fathom server
```

Se non ci sono errori di configurazione, il server è stato avviato correttamente e ha creato anche le tabelle nel DB (Potete verificarlo facendo un curl sulla porta 9000 per verificare l'effettiva risposta del server). Chiudete servizio premendo `ctrl+c`.

Come ultimo step di configurazione del servizio occorre creare l'utente per accedere all'interfaccia WEB:

```bash
$ cd /home/fathom
$ fathom register --email="john@email.com" --password="strong-password"
```

### Configurazione NGINX

NGINX nella nostra architettura verrà utilizzato come reverse proxy e terminatore SSL.

*Nel resto della guida utilizzerò `fathom.mysite.com` come dominio di esempio, ricordatevi di rimpiazzarlo con il vostro dominio nei successivi comandi / file di configurazione*

Creare un nuovo file `/etc/nginx/sites-available/fathom.mysite.com` con il seguente contenuto:

```nginx
server {
	server_name fathom.mysite.com;

	location / {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $remote_addr;
		proxy_set_header Host $host;
		proxy_pass http://127.0.0.1:9000;
	}
}
```

Attivare il sito creando un link simbolico in `sites-enabled`:

```bash
$ ln -s /etc/nginx/sites-available/fathom.mysite.com /etc/nginx/sites-enabled/
```

Verificare la corretta configurazione con:

```bash
$ nginx -t
$ service nginx reload
```

Per il momento NGINX è in ascolto sulla porta 80, quindi quello che rimane fare è configurare l'SSL con Let's Encrypt e fare in modo di redirigere tutto il traffico su HTTPS

Installare e configurare SSL è davvero semplice con il tool ufficale:

```bash
$ certbot --nginx -d fathom.mysite.com
```

**Nota:** Se è la prima volta che usate certbot, vi verrà richiesto di inserire un indirizzo mail e accettare i termini di servizio. Dopodiché certbot scambierà alcuni messaggi con i server di Let's encrypt e avvierà la "challange" con la quale verifica l'effettivo controllo del dominio per il quale è richiesto il certificato.

Se la challange di verifica del dominio è andata a buon fine otterrete questo output:

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

Selezionate la seconda opzione per forzare tutto il traffico tramite HTTPS.

Il certificato installato ha una validità di 90 giorni, ma è già prevista l'installazione automatica di un cronjob per effettuarne il rinnovo.
Solo per essere sicuri che tale procedura funzioni è possibile lanciare una simulazione:

```bash
$ sudo certbot renew --dry-run -d fathom.mysite
```

Se tutto è andato a buon fine Fathom è raggiungibile all'indirizzo https://fathom.mysite.com (se il servizio Fathom non è attivo lo potete avviare come fatto qualche comando fa).

### Avvio automatico del servizio

Per l'avvio automatico del servizio utilizzeremo systemd.

Prima di tutto creiamo il file `/etc/systemd/system/fathom.mysite.com.service` con il seguente contenuto:

```systemd
[Unit]
Description=Starts the fathom server
Requires=network.target
After=network.target

[Service]
Type=simple
User=fathom
Restart=always
WorkingDirectory=/home/fathom/
ExecStart=/usr/local/bin/fathom server

[Install]
WantedBy=multi-user.target
```

Ricaricare la configurazione e aggiungere la unit all'avvio del sistema:

```bash
$ systemctl daemon-reload
$ systemctl enable fathom.mysite.com
```

Infine avviare il servizio con:

```bash
$ systemctl start fathom.mysite.com
```

Fathom ora è pronto all'uso! L'ultima cosa che rimane da fare è l'integrazione con il nostro sito!

### Snippet per il tracking

Per attivare il tracking delle visite, occorre inserire questo script nella vostra pagina:

```html
<!-- Fathom - simple website analytics - https://github.com/usefathom/fathom -->
<script>
(function(f, a, t, h, o, m){
	a[h]=a[h]||function(){
		(a[h].q=a[h].q||[]).push(arguments)
	};
	o=f.createElement('script'),
	m=f.getElementsByTagName('script')[0];
	o.async=1; o.src=t; o.id='fathom-script';
	m.parentNode.insertBefore(o,m)
})(document, window, '//fathom.mysite.com/tracker.js', 'fathom');
fathom('trackPageview');
</script>
<!-- / Fathom -->
```

Ovviamente ricordatevi di sostituire `fatom.mysite.com` con il dominio che avete utilizzato per puntare al server appena configurato.

Per questa guida è tutto, spero di essere stato sufficientemente chiaro. Se riscontrate problemi non esitate a lasciare un commento!
