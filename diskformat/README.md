This folder contains two bootable floopy disk images used for creating bootable disk drives. When used with a virtual machine like QEMU, they can serve as a host-independent alternative to tools like [ms-sys](https://github.com/pbatard/ms-sys).

The first floppy disk (`boot1.img`) boots into FreeDOS, and uses the [FDISK](https://github.com/FDOS/fdisk) utility to create a new FAT32 extended partition on an attached hard drive (or hard drive image, when used with a VM). It also installs a [Master Boot Record](https://en.wikipedia.org/wiki/Master_boot_record) and sets the partition as active, which allows FreeDOS to boot later.

The second floppy disk (`boot2.img`) boots into FreeDOS, and uses the [FORMAT](http://wiki.freedos.org/wiki/index.php/Format) program to format the partition created by FDISK and install FreeDOS system files.

Both disks use [FDAPM](http://wiki.freedos.org/wiki/index.php/FDAPM) to shut down the system after each task is completed, so they can be used in an automated/headless environment (like the Cobalt setup script).