---
authors:
- hypertesto
categories:
- articolo
cover: /images/tim-mossholder-322350-unsplash.jpg
date: "2019-05-06T00:00:00+02:00"
tags:
- AV1
- test
title: Il mio primo test su strada con SVT-AV1
---
Al National Association of Broadcasters Show (NAB Show) 2019 di Las Vegas, Intel e Netflix hanno presentato il codec video open source [SVT-AV1](https://github.com/OpenVisualCloud/SVT-AV1/), acronimo di _Scalable Video Technology for AV1_.

Il codec è concepito per ottenere il miglior compromesso fra latenza, performance e qualità visiva rispetto alle attuale implementazioni AV1: [libaom](https://aomedia.googlesource.com/aom/) che non brilla certo in termini di performance.

Ma prima di partire; cos'è [AV1](https://it.wikipedia.org/wiki/AOMedia_Video_1)?

AV1 è un codec video open source. È pensato per l'utilizzo in ambito web per fare in modo che piattaforme video o i produttori di dispositivi non paghino royalty alla Moving Picture Experts Group (MPEG), lo sviluppatore di codec come H.264 e HEVC (che sono utilizzati un po' ovunque).

Il progetto vanta il supporto di tutti i più grandi player di settore:

![](/images/aomedia_members.png)

Essendo nato con una forte vocazione al web (streaming), il suo obiettivo è quello di ottenere dei file video di piccole dimensioni poiché ciò permette un notevole risparmio di banda per la distribuzione di video su scala globale.

### Test su strada

Ho voluto provare velocemente quanto è più veloce rispetto all'implementazione di riferimento (liboam) tentando un encode di un due minuti di video alla risoluzione di 720x480 pixel:

```bash
Stream #0:0: Video: h264 (High), yuv420p(progressive), 720x480 [SAR 1:1 DAR 3:2], SAR 186:157 DAR 279:157, 29.97 fps, 29.97 tbr, 1k tbn, 59.94 tbc (default)
```

L'encode con libaom tarmite ffmpeg ha uno speedup (sulla mia macchina) dello 0.03x in media... Immaginate quanto può durare la codifica di un film!

Questo è il test con liboam:

```bash
$ ffmpeg -i SOURCE.mkv -c:v libaom-av1 -crf 34 -b:v 0 -pix_fmt yuv420p -strict experimental video.av1.mp4
Input #0, matroska,webm, from 'SOURCE.mkv':
  ... Output rimosso per chiarezza
    Stream #0:0: Video: av1 (libaom-av1) (av01 / 0x31307661), yuv420p, 720x480 [SAR 186:157 DAR 279:157], q=-1--1, 29.97 fps, 11988 tbn, 29.97 tbc (default)
    Metadata:
      DURATION        : 00:02:00.079000000
      encoder         : Lavc58.35.100 libaom-av1
    Side data:
      cpb: bitrate max/min/avg: 0/0/0 buffer size: 0 vbv_delay: -1
    Stream #0:1(eng): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, 5.1(side), fltp, 394 kb/s (default)
    Metadata:
      DURATION        : 00:02:00.000000000
      encoder         : Lavc58.35.100 aac
frame=   30 fps=0.7 q=0.0 size=       0kB time=00:00:01.25 bitrate=   0.6kbits/s dup=4 drop=0 speed=0.0309x
```

Inutile dire che ho interrotto prima che producesse l'output.

Invece questo è il test con SVT-AV1:

```bash
$ ffmpeg -i ~/Video/SOURCE.mkv -nostdin -f rawvideo -pix_fmt yuv420p - | ./SvtAv1EncApp -i stdin -n 3600 -w 720 -h 480 -b /home/hypertesto/Video/TEST.ivf
... [output rimosso] ...
SVT [version]:	SVT-AV1 Encoder Lib v0.4.0
SVT [build]  :	GCC 7.4.0	 64 bit
LIB Build date: May  6 2019 21:45:54
-------------------------------------------
Number of logical cores available: 8
Number of PPCS 72
-------------------------------------------
SVT [config]: Main Profile	Tier (auto)	Level (auto)
SVT [config]: EncoderMode 							: 8
SVT [config]: EncoderBitDepth / EncoderColorFormat / CompressedTenBitFormat	: 8 / 1 / 0
SVT [config]: SourceWidth / SourceHeight					: 720 / 480
SVT [config]: FrameRate / Gop Size						: 30 / 32
SVT [config]: HierarchicalLevels / BaseLayerSwitchMode / PredStructure		: 4 / 0 / 2
SVT [config]: BRC Mode / QP  / LookaheadDistance / SceneChange			: CQP / 50 / 33 / 0
-------------------------------------------
Encoding          frame=   11 fps=0.0 q=-0.0 size=    5569kB time=00:00:00.36 bitrate=124291.5kbits/s dup=2 drop=0 spe        3frame=   76 fps= 72 q=-0.0 size=   38475kB time=00:00:02.53 bitrate=124291.6kbits/s dup=13 drop=0 speed=2.41x       15frame=   92 fps= 58 q=-0.0 size=   46575kB time=00:00:03.06 bitrate=124291.6kbits/s dup=16 drop=0 speed=1.92x
... [output rimosso] ...
video:1821994kB audio:0kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.000000%
     4000
Average System Encoding Speed:        58.51
```

La velocità media è risultata 58.51fps, quindi poiché il video è a 30 fps lo speedup è di circa 1.9x. Niente male davvero!

Quello che è davvero notevole è la differenza di dimensione tra i due file:

```bash
$ ls -sh
26M /home/hypertesto/Video/SOURCE.mkv
3,0M /home/hypertesto/Video/TEST.ivf
```

Il video a una prima analisi con mpv presenta alcuni artefatti rispetto all'originale: stiamo sempre parlando di encoder e decoder del tutto sperimentali, perciò mi aspetto grandi miglioramenti già nell'immediato vista l'attenzione ricevuta recentemente da tutti i big del mondo video.
