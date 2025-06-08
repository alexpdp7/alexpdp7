# Ripping

## Media

[Main source](https://arstechnica.com/civis/threads/ripping-optical-media.1507399/post-43734994).

### Audio CD

About 200-300 MB per album CD when ripped to FLAC.

### DVD

About 4-8 GB per disc, averaging 5.6 GB per movie as ISO.

### Blu-ray

About 20-50 GB per disc, averaging 37 GB per movie as ISO.

## Hardware

### Reader

I got a Verbatim external USB Blu-ray writer for about 120€.

### Storage

See <https://diskprices.com/>.

## Software

### Audio

* [abcde](https://abcde.einval.com/wiki/) claims to rip and compress to FLAC and tag automatically.

### Video

You can use `dd` to rip DVD and Blu-ray.
However, `dd` can fail on some disks, perhaps due to damage or copy protection.
[This post on unix.stackexchange describes a trick that works](https://unix.stackexchange.com/a/642790):

* Start playback of the disc using [VLC media player](https://www.videolan.org/vlc/)
* Run a command like `ddrescue -n -b2048 -K1M /dev/sr0 x.iso x.map`
* After `ddrescue` starts running, pause playback.

[FindVUK](http://fvonline-db.bplaced.net/) has the keys to rip Blu-ray discs.
