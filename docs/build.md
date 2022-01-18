# Building and testing Cobalt

Clone the repository, then run the compile script. You need `mkisofs` installed and a Linux host.
```
./compile.sh
```
This will generate a bootable ISO image at `dist/cobalt.iso`. This can be written to a physical CD/USB or used with a virtual machine.

If you clone the repository, you can also compile an ISO with GitHub Actions by navigating to `Actions > Build Nightly > Run workflow`.

The CD uses a floppy disc image for the initial boot process, which can be mounted for editing with the `mount-floppy` script.
```
./mount-floppy.sh
```