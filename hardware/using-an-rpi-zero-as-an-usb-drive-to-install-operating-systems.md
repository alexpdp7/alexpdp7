# Using an RPI Zero as an USB drive to install operating systems

If you install operating systems, then you might have suffered the annoyances of writing images to USB drives.
To write an operating system to a USB drive, you must wipe the entire contents of the USB drive.
So a USB drive can only contain a single operating system.

There are alternatives:

* iODD sells external USB drives that can emulate CDROM drives.
* netboot.xyz and other netboot images can boot operating systems over the network.
* Multiboot USB software like Ventoy or YUMI.

## Using a Raspberry Pi Zero

Linux devices can emulate USB mass storage devices (and other kinds of USB devices).

However, powering a Linux device using a USB port might draw more current than it is safe, damaging the device powering the Linux device (e.g. a laptop you want to boot from USB).

A simple option is getting a Raspberry Pi Zero (I used the 2 W model) with the [EP-0097](https://wiki.52pi.com/index.php/EP-0097) USB adapter.
This should be safe.
However, without any additional setup, the procedures I describe only work when using an always-on USB port.

(Assembling the Raspberry Pi Zero into the USB adapter is straightforward.
However, I was confused: you must mount the thin acrylic shield below the USB dongle extension board, then the thick shield over the board, then the Raspberry Pi.)

1. Use the Raspberry Pi Imager to create a MicroSD card for your Raspberry Pi Zero, configuring remote access via SSH and your wireless network.
1. Connect the Raspberry Pi with the adapter into an always-on USB port of the device you want to use.
1. Stall the device boot process until you set everything up on the Raspberry.
1. Connect via ssh over wireless to the Raspberry Pi.
1. Download the image you want to use.
1. Use the `rmmod` command to remove any modules starting with `g_`.
1. Run `modprobe g_mass_storage file=/path/to/image`
1. After running this command, the device should be able to boot the image.

### Notes

* You can run a command such as `while date ; do sleep 1 ; done` to monitor that the Raspberry Pi does not reboot or poweroff.
