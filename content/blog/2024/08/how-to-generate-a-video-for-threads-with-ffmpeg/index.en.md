---
title: "How to generate a video for Threads with ffmpeg"
date: 2024-08-17T22:34:55+02:00
draft: false
description: ""
---
Today I wanted to generate a small teaser of an AI generated song I produced for a D&D campaign in order to share it on Threads. Sounds like an easy task but I had to overcome some limitation:  
while from its mobile app you can send voice notes, Threads doesn't allow for standard audio files like an mp3, so I had to generate a video.

I quickly hacked together this command that given the audio file an image, it uses them to produce a video with the image in loop.

{{< alert >}}
**Warning!** The next command is not the correct one, if you are in a hurry jump straight to the end of the article.
{{< /alert >}}

```bash
ffmpeg -loop 1 -i sollevamento_nanico.webp -i sollevamento_nanico-teaser.mp3 -shortest sollevamento_nanico-teaser.mp4
```

The generated file had this spec:

```
Output #0, mp4, to 'sollevamento_nanico-teaser.mp4':
  Metadata:
    encoder         : Lavf60.16.100
  Stream #0:0: Video: mpeg4 (mp4v / 0x7634706D), yuv420p(tv, bt470bg/unknown/unknown, progressive), 1024x1024, q=2-31, 200 kb/s, 25 fps, 12800 tbn
    Metadata:
      encoder         : Lavc60.31.102 mpeg4
    Side data:
      cpb: bitrate max/min/avg: 0/0/200000 buffer size: 0 vbv_delay: N/A
  Stream #0:1: Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 128 kb/s
```

Unlucky for me Threads can't reproduce it, so I digged a bit into the [API documentation](https://developers.facebook.com/docs/threads/overview/) and I gathered more information:

```
Video Specifications
    Container: MOV or MP4 (MPEG-4 Part 14), no edit lists, moov atom at the front of the file.
    Audio Codec: AAC, 48khz sample rate maximum, 1 or 2 channels (mono or stereo).
    Video Codec: HEVC or H264, progressive scan, closed GOP, 4:2:0 chroma subsampling.
    Frame Rate: 23-60 FPS
    Picture Size:
        Maximum Columns (horizontal pixels): 1920
        Required aspect ratio is between 0.01:1 and 10:1 but we recommend 9:16 to avoid cropping or blank space.
    Video Bitrate: VBR, 25 Mbps maximum.
    Audio Bitrate: 128 kbps.
    Duration: 300 seconds (5 minutes) maximum, minimum longer than 0 seconds.
    File Size: 1 GB maximum.
```

Bingo! My file had two issues:
- wrong video codec
- moov atom not at the beginning of the file

Fixing it is a straightforward task in ffmpeg:

```bash
ffmpeg -loop 1 -i sollevamento_nanico.webp -i sollevamento_nanico-teaser.mp3 -shortest -c:v libopenh264 -movflags faststart sollevamento_nanico-teaser.mp4
```

Notice that I used `libopenh264` instead of `libx264` since the latter is not available on Fedora due to patent issues; nothing prevents you from installing it, but for a 10 second video it doesn't make any difference.

This was a very quick and dirty solution, I hope it will be useful to someone.

Comments are open if you need some help or want to discuss.