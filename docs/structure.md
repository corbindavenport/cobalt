# Cobalt structure

This document outlines the structure of the Cobalt repository.

## cdroot/

This folder contains everything in the Cobalt Live CD, including the main installer, the repair script, and the required files for running [ISOLINUX](https://wiki.syslinux.org/wiki/index.php?title=ISOLINUX).

- **tools/** - All software used for the system installer that does not have to be loaded in `config.sys` (the rest is in `btdsk.img`). All software is from the FreeDOS software archives.
- **isolinux/** - Files required for booting from the CD, including `btdsk.img`, which is a FreeDOS 1.1 boot floppy with CD drivers. The floppy disk image can be opened with `mount-floppy.sh`.

## sysroot/

The contents of this folder are extracted to the target drive during Cobalt installation. The `compile.sh` script compresses the contents into a `system.zip` file, which is then placed in the cdroot folder.

## dist/

This folder is generated after running `compile.sh`, and contains a bootable ISO image.