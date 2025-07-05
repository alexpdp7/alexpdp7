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

#### DVD

Use `dd` to rip DVD.
However, `dd` can fail on some disks, perhaps due to damage or copy protection.
[This post on unix.stackexchange describes a trick that works](https://unix.stackexchange.com/a/642790):

* Start playback of the disc using [VLC media player](https://www.videolan.org/vlc/).
* Try `dd` first, if it fails, then run a command like `ddrescue -n -b2048 -K1M /dev/sr0 x.iso x.map`.
* After `ddrescue` starts running, quit VLC.

For playback, most software (including Kodi and VLC for Android) can play back DVD ISO with full menu support

#### Blu-ray

[FindVUK](http://fvonline-db.bplaced.net/) has the keys to play Blu-ray discs ripped with `dd`.
However, with encrypted Blu-ray discs, you need to configure the keys in each device where you want to play back the content.
(And this is not easy or possible in some cases.)

[blu-save](https://git.sr.ht/~shironeko/blu-save) can remove the encryption.
Remember to specify the path to the keys when running blu-save.

However, VLC is confused by the `AACS` and `CERTIFICATE` directories that blu-save copies to the output.
If you remove them, then VLC can play the `BDMV` directory with menus, etc.

You can repack a Blu-ray extracted with blu-save by running a command like:

```
mkisofs -allow-limited-size -o .../my.iso .
```

from the directory that contains *only* the `BDMV` directory.

VLC for desktop computers can open a repacked Blu-ray ISO and show the menus.
Kodi for Android can open a repacked Blu-ray ISO and identify the titles.
However, Kodi did not support the menus for the Blu-ray I tested.
