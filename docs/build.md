# Building and testing Cobalt

Clone the repository to a Linux host, then run the compile script:

```
./compile.sh
```

This will generate a bootable ISO image at `dist/cobalt.iso`. This can be written to a physical CD/USB or used with a virtual machine.

This process involves downloading FreeDOS packages listed in `packages.txt` and placing them in the `tmp/` folder. If you modify the list and need to refresh the downloaded packages, run the script with the flag:

```
./compile.sh --force-rebuild
```

If you clone the repository, you can also compile an ISO with GitHub Actions by navigating to `Actions > Build Nightly > Run workflow`.

The CD uses a floppy disc image for the initial boot process, which can be mounted for editing with the `mount-floppy` script.
```
./mount-floppy.sh
```