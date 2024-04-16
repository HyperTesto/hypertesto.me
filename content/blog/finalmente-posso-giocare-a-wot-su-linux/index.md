---
authors:
- hypertesto
categories:
- articolo
date: "2019-03-25T22:28:20+01:00"
draft: false
tags:
- games
- wine
title: Finalmente posso giocare a WoT Su Linux
---
Vi è mai capitato di avere quella voglia di rispolverare quel gioco che non toccate da un paio d'anni? Bè a me è successo un po' di volte, solo che non avendo più una singola installazione Windows alla fine sono sempre andato in _fallback_ su DOTA 2 che gira tranquillamente con Steam anche sul sistema operativo del pinguino.

La settimana scorsa per curiosità ho installato Mint 19.1 sul mio nuovo disco NVMe fiammante, così per sfizio ho deciso di fare un tentativo e installare World of Tanks tramite [Wine][b7d9071d].


{{< figure src="/images/wot.png" caption="Il mio garage. Mi mancava ❤️" >}}

Non solo ci sono riuscito senza troppe difficoltà, ma gira che è una meraviglia! Ovviamente non ha le stesse performance che ha su Windows, intendiamoci.

A titolo informativo questi sono i dati di targa del mio PC:

```bash
hypertesto@avalen:~/Sorgenti/hypertesto.me$ inxi -F
System:    Host: avalen Kernel: 4.15.0-20-generic x86_64 bits: 64 Desktop: MATE 1.20.1 Distro: Linux Mint 19.1 Tessa
Machine:   Type: Desktop Mobo: Micro-Star model: B350 PC MATE (MS-7A34) v: 2.0 serial: <root required>
           UEFI [Legacy]: American Megatrends v: A.60 date: 07/27/2017
CPU:       Topology: Quad Core model: AMD Ryzen 5 1500X bits: 64 type: MT MCP L2 cache: 2048 KiB
           Speed: 1378 MHz min/max: 1550/3500 MHz Core speeds (MHz): 1: 1377 2: 1380 3: 1378 4: 1377 5: 1377 6: 1375 7: 1375
           8: 1377
Graphics:  Device-1: NVIDIA GM107 [GeForce GTX 750 Ti] driver: nvidia v: 418.56
           Display: x11 server: X.Org 1.19.6 driver: nvidia resolution: 1920x1080~60Hz
           OpenGL: renderer: GeForce GTX 750 Ti/PCIe/SSE2 v: 4.6.0 NVIDIA 418.56
Audio:     Device-1: NVIDIA driver: snd_hda_intel
           Device-2: Advanced Micro Devices [AMD] Family 17h HD Audio driver: snd_hda_intel
           Sound Server: ALSA v: k4.15.0-20-generic
Network:   Device-1: Qualcomm Atheros AR9227 Wireless Network Adapter driver: ath9k
           IF: wlp32s1 state: down mac: 50:3e:aa:45:3c:b4
           Device-2: Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet driver: r8169
           IF: enp33s0 state: down mac: 30:9c:23:3e:5e:bb
           Device-3: ZTE WCDMA MSM type: USB driver: cdc_ether,usb-storage
           IF: enp3s0f0u10 state: up speed: N/A duplex: N/A mac: 5a:ae:85:b7:91:96
Drives:    Local Storage: total: 1.14 TiB used: 101.96 GiB (8.8%)
           ID-1: /dev/nvme0n1 vendor: Samsung model: SSD 970 EVO 250GB size: 232.89 GiB
           ID-2: /dev/sda vendor: Western Digital model: WD10EZEX-00BN5A0 size: 931.51 GiB
Partition: ID-1: / size: 220.90 GiB used: 52.24 GiB (23.6%) fs: ext4 dev: /dev/nvme0n1p5
           ID-2: swap-1 size: 7.45 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/nvme0n1p1
           ID-3: swap-2 size: 9.31 GiB used: 0 KiB (0.0%) fs: swap dev: /dev/sda5
Sensors:   System Temperatures: cpu: 39.1 C mobo: N/A gpu: nvidia temp: 27 C
           Fan Speeds (RPM): N/A gpu: nvidia fan: 30%
Info:      Processes: 239 Uptime: 21m Memory: 7.80 GiB used: 1.61 GiB (20.7%) Shell: bash inxi: 3.0.27
```

Non un mostro, ma nemmeno un macinino da caffè!

## Prerequisiti
Per far funzionare tutta la baracca servono queste cose:

* Una scheda video che supporti [DXVK][0efe3bf7] ([lista delle GPU supportate][db2a8210])
* Per GPU Nvidia (il mio caso) driver alla versione 415.22 o superiore (per le altre GPU vi rimando alla [pagina ufficiale][d65d43e5])
* Wine staging
* [Lutris][7c9fce6e]
* Un po' di pazienza!

## Installazione
Il processo di installazione l'ho diviso in tre fasi così da risultare più fruibile.

**WARNING:** Questo procedimento è testato su Linux Mint 19.1 fresco di installazione, non so se possa andar bene anche in altri scenari.

### Driver Nvidia
Per l'installazione NVIDIA occorre scaricare i driver dal sito ufficiale, poiché i driver dei repository non sono sufficientemente aggiornati.

Prima di tutto scarichiamo in una cartella (nel mio esempio la home) il file binario:

```bash
$ cd ~
$ wget http://us.download.nvidia.com/XFree86/Linux-x86_64/418.56/NVIDIA-Linux-x86_64-418.56.run
```
**Assicuratevi di non avere nulla di aperto poiché il resto della procedura prevede il fermo della sessione X attiva.**

Premere i tasti `ctrl + alt + F1` per aprire una nuova TTY, effettuare il login

Fermare la sessione X e successivamente avviare il processo di installazione con:

```bash
$ sudo service lightdm stop
$ chmod +x NVIDIA-Linux-x86_64-418.56.run
$ ./NVIDIA-Linux-x86_64-418.56.run
```

Se tutto va per il verso giusto compariranno a schermo alcuni dialog con cui accettare la licenza e confermare la sovrascrittura del file di configurazione di X.

Al termine dell'installazione riavviare il PC con il comando:
```bash
$ reboot
```

### Wine staging
Difficile non conoscere Wine se, come me, vi siete mai cimentati con i videogiochi su Linux. Per chi non lo conosce semplicemente un layer di compatibilità che permette alle applicazioni Windows di girare, nei limiti del possibile, sui sistemi POSIX. Attenzione che non è un emulatore, ma bensì un sistema che traduce al volo chiamate alle API Windows in chiamate alle API POSIX.

Per installare Wine staging lanciare questi comandi da terminale:
```bash
$ sudo dpkg --add-architecture i386
$ wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
$ sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
$ sudo apt update && sudo apt install wine-staging-i386
$ sudo apt install --install-recommends wine-staging winehq-staging
```

### Lutris
Prima di passare al lato pratico, lascio giusto due parole su cos'è Lutris e perchè è comodo da utilizzare: semplicemente è il [pacman][5ea28501] per Wine! Qualche santo pacchettizza uno script di installazione funzionante e lo mette a disposizione della community (e se avete mai bisticciato con Wine sapete quanto è dura trovare una configurazione funzionante).

Per l'installazione basta seguire la [guida ufficiale][9678fa76], che riporto qui per comodità:
```bash
$ ver=$(lsb_release -sr); if [ $ver != "18.10" -a $ver != "18.04" -a $ver != "16.04" ]; then ver=18.04; fi
$ echo "deb http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
$ wget -q https://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/Release.key -O- | sudo apt-key add -
$ sudo apt update && sudo apt-get install lutris  
```
Se tutto è andato a buon fine ora potete lanciare Lutris e cominciare il processo di installazione di WoT.

Nella barra di ricerca cercate "World of Tanks", cliccate sulla voce che compare e infine su "Install". Da qui in poi basterà seguire la procedura guidata (leggi: premere OK in modalità scimmia).

{{< figure src="/images/lutris.png" caption="Ricerca tramite Lutris" >}}

Un ultimo bit di informazione: il gioco non esce direttamente, ma lascia la sessione Windows fake attiva, quindi per spegnere potete semplicemente usare una combinazione di tasti per spostarvi tra una finestra e l'altra (o per aprire il menu principale) e chiudere direttamente dalla barra delle applicazioni.

<center>**🎮🎮 Divertitevi 🎮🎮**</center>

  [9678fa76]: https://lutris.net/downloads/ "installazione Lutris - guida ufficiale"
  [5ea28501]: https://wiki.archlinux.org/index.php/Pacman_(Italiano) "pacman arch linux"


  [b7d9071d]: https://www.winehq.org "Wine"
  [0efe3bf7]: https://github.com/doitsujin/dxvk "DXVK"
  [db2a8210]: https://en.wikipedia.org/wiki/Vulkan_(API)#Compatibility "Lista delle GPU con supporto DXVK"
  [d65d43e5]: https://github.com/doitsujin/dxvk/wiki/Driver-support "Driver GPU per supporto DXVK"
  [7c9fce6e]: https://lutris.net/ "Lutris"
