+++
cover = ""
date = "2019-05-06T00:00:00+02:00"
draft = true
title = "Il mio primo test su strada con SVT-AV1"

+++
Al National Association of Broadcasters Show (NAB Show) 2019 di Las Vegas, Intel e Netflix hanno presentato il codec video open source SVT-AV1, acronimo di _Scalable Video Technology for AV1_.
Il codec è concepito per ottenere il miglior compromesso fra latenza, performance e qualità visiva rispetto alle attuali implementazioni<sup>[1](https://aomedia.googlesource.com/aom/)</sup> <sup>[2](https://github.com/xiph/rav1e)</sup>.

L'encode con l'implementazione di riferimento (libaom) tarmite ffmpeg ha uno speedup (sulla mia macchina) dello 0.03x in media... immaginate quanto può durare la codifica di un film!

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


```bash
$ ffmpeg -i ~/Video/SOURCE.mkv -nostdin -f rawvideo -pix_fmt yuv420p - | ./SvtAv1EncApp -i stdin -n 3600 -w 720 -h 480 -b /home/hypertesto/Video/TEST.ivf
```