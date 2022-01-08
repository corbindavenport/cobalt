# Cobalt

Cobalt is an operating system based on FreeDOS and the [older Cobalt OS](https://github.com/Cobalt-OS/Cobalt) project. It's still very early in development.

### Building and testing Cobalt

Clone the repository, then run the compile script. You need `mkisofs` installed and a Linux host.
```
./compile.sh
```
This will generate a bootable ISO image at `bin/cobalt.iso`. This can be written to a physical CD/USB or used with a virtual machine.

The CD uses a floppy disc image for the initial boot process, which can be mounted for editing with the `mount-floppy` script.
```
./mount-floppy.sh
```

---

The Cobalt distribution (everything in this repository) is licensed under the GNU General Public License v3, but Cobalt contains binaries from the [FreeDOS Project](https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/1.3/pkg-html/index.html0) that may be under different licenses.