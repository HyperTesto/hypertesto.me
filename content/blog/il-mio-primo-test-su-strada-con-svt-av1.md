+++
cover = ""
date = "2019-05-06T00:00:00+02:00"
draft = true
title = "Il mio primo test su strada con SVT-AV1"

+++
Al National Association of Broadcasters Show (NAB Show) 2019 di Las Vegas, Intel e Netflix hanno presentato il codec video open source SVT-AV1, acronimo di *Scalable Video Technology for AV1*.
Il codec è concepito per ottenere il miglior compromesso fra latenza, performance e qualità visiva rispetto alle attuali implementazioni<sup>[1](https://aomedia.googlesource.com/aom/)</sup> <sup>[2](https://github.com/xiph/rav1e)</sup>.



```bash
$ ffmpeg -i ~/Video/CIT/Hell\ Girl\ S1/SOURCE.mkv -nostdin -f rawvideo -pix_fmt yuv420p - | ./SvtAv1EncApp -i stdin -n 3600 -w 720 -h 480 -b /home/hypertesto/Video/TEST.ivf
```

