# Building and testing Cobalt

## Installing prerequisites

The compile script for Cobalt requires a Bash-compatible shell. You also need the below packages installed or the script will fail.

- `mkisofs`, for generating the ISO disc image.
- `zip` and `unzip`, for unzipping FreeDOS packages and zipping up installation files.

If you're on a Debian-based Linux distribution, this command will install all prerequisites:

```
sudo apt install -y mkisofs zip unzip
```

On macOS, you probably only need `mkisofs` which can be installed with [Brew](https://brew.sh/):

```
brew install cdrtools
```

## Building a Cobalt install CD

Clone the repository, then run the below command in the root directory:

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