+++
authors = ["hypertesto"]
categories = ["guide"]
cover = "/images/schermata-a-2020-07-08-21-50-14.png"
date = 2020-07-08T19:00:00Z
draft = true
tags = ["linux", "server", "remote desktop"]
title = "Installare X2Go su Ubuntu 18.04"

+++
_Ovvero: ho finalmente trovato una soluzione decente per connettermi in remote desktop sul portatile che ho lasciato in ufficio. Uncle singer._

Probabilmente ci avrete sbattuto la testa anche voi dato che nell'ultimo periodo per cause di forza maggiore stiamo sperimentando l'ebrezza del lavoro remoto (no, non vi darò la soddisfazione di chiamarlo "smart working").

Non sono un amante dei desktop remoti; la maggior parte delle volte mi basta una connessione SSH, tuttavia ogni tanto ho bisogno di accedere a qualche tool grafico. 

Puntualmente ogni volta è un supplizio:

* **TeamViewer** rogna ogni tre per due tra sospetto uso commerciale, differenze tra versioni, ecc...
* **AnyDesk** funziona, ma non troppo. Sarebbe anche figo dato che è praticamente un clone meno rompiballe di TeamViewer, però non riesco mai ad avere una sessione priva di disconnessioni o caratteri sparati a ripetizione ogni volta che premo troppo rapidamente qualche tasto.
* **TightVNC** non mi ha dato mai problemi di stabilità, ma almeno che non siate connessi in fibra sia sul server che sul client, la qualità grafica è talmente bassa che rende impossibile fare alcune operazioni piuttosto basilari. Peccato perchè è facile da installare ed è anche open source.
* **TigerVNC** valgono grossomodo le stesse considerazioni di TigerVNC

Collegandomi in ufficio in VPN, non ho bisogno di cose particolari per aprire porte dinamicamente, perciò da questo punto di vista soluzioni come TeamWiever/AnyDesk non sono strettamente necessarie. 

In questi giorni  mi sono messo a fare esperimenti e ho trovato un altro fantastico progetto open source: [X2Go](https://wiki.x2go.org/doku.php "X2Go").

Il sito non ispira molta fiducia, ma vi garantisco che ha superato le mie più rosee aspettative:

* si installa in due minuti
* è leggerissimo
* fa tunnel con SSH (e questo è figo sia dal punto di vista della sicurezza del traffico ed è anche una semplificazione se c'è di mezzo qualche firewall)
* il consumo di banda è davvero molto ottimizzato

Quindi veniamo a noi e vediamo come si installa su Ubuntu 18.04 e praticamente qualsiasi derivata.

### Scelta del DE

X2Go è compatibile con i principali DE, nel mio caso sto utilizzando MATE (poiché sono su Mint). Ho testato con successo anche XFCE.

Consiglio mio: usate qualcosa di leggero senza troppe gigiate grafiche, quelle sicuramente non aiutano se avete poca banda.

### Installazione server

Il server non si trova nei repo di default, perciò è necessario installarlo aggiungendo prima il relativo PPA:

    $ sudo apt-add-repository ppa:x2go/stable

E successivamente lo si installa normalmente

    $ sudo apt-get update
    $ sudo apt-get install x2goserver x2goserver-xsession

### Installazione del client

Il client, al contrario del server, è già presente nei repo di default, perciò è sufficiente installarlo con:

    $ sudo apt-get install x2goclient

### Configurazione

L'interfaccia del client è piuttosto semplice, una volta avviato basterà aggiungere una nuova "sessione":

![](/images/x2go_1.png)

###### **Tab "Session"**

Dalla prima tab impostate l'indirizzo IP del server e l'utente SSH con il quale accedete. Se non avete configurazioni strane è più che sufficiente.

Poi in basso selezionate dal menù a tendina il DE presente sul server.

###### **Tab "Connection"**

Da questa tab è possibile aggiustare con uno slider la banda a vostra disposizione. Nel mio caso il default "ADSL" è andato benissimo.

###### **Tab "Input/Output"**

Da questa tab impostate la risoluzione della finestra (ad esempio io ho utilizzato 1280x1024), ma potete anche mettere un generico schermo intero.![](/images/x2go_2.png)

Qualora il layout della tastiera non venga riconosciuto in automatico è possibile impostarlo a mano selezionando la voce "Configure keyboard".

Vi faccio notare una piccola chicca: **di default è supportato il copia-incolla bidirezionale**.

Se non avete esigenze particolari questo è tutto ciò che dovete configurare. Basta dare OK e poi dalla schermata principale fare doppio click sulla sessione. Da lì poi inserite le credenziali di accesso e siete in desktop remoto.

### Considerazioni finali

Come ho già avuto modo di dire, sono rimasto sbalordito dalla qualità si X2Go. L'ho utilizzato una decina di ore facendo prove di connessioni da ADSL di casa, Iliad, Ho Mobile e tranne qualche inevitabile laggata (vivo in montagna, internet stabile qui è ancora un sogno) non mi sembrava di essere in remoto.

Ho volutamente tralasciato il discorso apertura porte poichè facendo tunnel via SSH, valgono le regole che applichereste ad esso.