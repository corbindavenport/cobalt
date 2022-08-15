#!/bin/bash
DIR="$(pwd "${BASH_SOURCE[0]}")"
PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"
PARAM=$1

function get_dependencies {
  # Delete tmp folder if already present
  rm -rf "$DIR/tmp"
  # Delete system bin folder if needed
  rm -rf "$DIR/sysroot/system/bin"
  # Delete source zip folder if needed
  rm -f "$DIR/cdroot/source.zip"
  # Start downloading dependencies
  mkdir -p "$DIR/tmp"
  while IFS="" read -r p || [ -n "$p" ]; do
    # Split package name
    IFS="/" 
    read -a PACKAGE <<< "$p"
    # Download
    echo "Downloading package: $p"
    curl --progress-bar -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.80 Safari/537.36 Edg/98.0.1108.43" --max-time 15 -o "$DIR/tmp/${PACKAGE[1]}.zip" "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/$p.zip"
    # Create single BIN folder from all zip files
    unzip -o "$DIR/tmp/${PACKAGE[1]}.zip" "BIN/*" "bin/*" "APPS/*" "apps/*" -x "*/_*" "*/*.HLP" -d "$DIR/tmp/"
    # Create source folder
    unzip -o "$DIR/tmp/${PACKAGE[1]}.zip" "SOURCE/*" "source/*" -x "*/_*" -d "$DIR/tmp/"
  done < "$DIR/packages.txt"
  # Zip up combined source folder and move it to the CD
  cd "$DIR/tmp/SOURCE"
  zip -r "$DIR/cdroot/source.zip" *
  cd "$DIR"
  # Move binaries to system folder
  mkdir -p "$DIR/sysroot/system/bin"
  cp -f -r tmp/BIN/* sysroot/system/bin
  if [ -d "$DIR/tmp/APPS" ]; then
    cp -f -r tmp/APPS/* sysroot/system/bin
  fi
}

function generate_usb_image {
  # TODO: Check if there is already /dev/loop1, and set size based on size of files (with min as 50MB)
  echo "Generating USB image..."
  rm -f "$DIR/dist/cobalt-usb.img"
  # Create blank disk image
  dd if=/dev/zero of="$DIR/dist/cobalt-usb.img" iflag=fullblock bs=1M count=50 && sync
  # Boot QEMU
  echo "Initializing USB image..."
  qemu-system-i386 -m 32 -k en-us -rtc base=localtime -soundhw sb16,adlib -device cirrus-vga -nographic -hda "$DIR/dist/cobalt-usb.img" -fda "$DIR/diskformat/boot1.img" -boot a &> /dev/null
  echo "Creating system on USB image..."
  qemu-system-i386 -m 32 -k en-us -rtc base=localtime -soundhw sb16,adlib -device cirrus-vga -nographic -hda "$DIR/dist/cobalt-usb.img" -fda "$DIR/diskformat/boot2.img" -boot a &> /dev/null
  # Mount disk image
  echo "Mounting image..."
  sudo mkdir -p "$DIR/tmpmount"
  sudo kpartx -a -v "$DIR/dist/cobalt-usb.img"
  sudo mount /dev/mapper/loop0p1 "$DIR/tmpmount"
  # Write files
  echo "Copying files to image..."
  cd "$DIR/usbinstallroot"
  sudo cp -r * "$DIR/tmpmount"
  # Unmount disk image
  echo "Unmounting image..."
  sudo umount "$DIR/tmpmount"
  sudo kpartx -d -v "$DIR/dist/cobalt-usb.img"
  sudo losetup -d /dev/loop0
  rm -rf "$DIR/tmpmount"
}

cd "$DIR"

# Check for sudo
sudo echo "Sudo access granted."

mkdir -p "$DIR/dist"

# Download FreeDOS packages

if [ "$PARAM" == "--force-rebuild" ]; then
  get_dependencies
elif ! [ -d "$DIR/tmp" ]; then
  get_dependencies
else
  echo "FreeDOS packages already downloaded, skipping..."
fi

# Save build date to CD

DATE="$(date)"
STR+=" Build Date: $DATE"
echo "$STR" > "$DIR/cdroot/date.txt"

# Generate ZIP file for installer

cd "$DIR/sysroot"
zip -r "$DIR/cdroot/system.zip" * -x *.md
cd "$DIR"

# Create folder where ISO and USB image will be stored
mkdir -p "$DIR/dist"

# Generate ISO

echo "Generating ISO..."
mkisofs -o "$DIR/dist/cobalt.iso" -publisher "$PUBLISHER" -V "$TITLE" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c boot.cat cdroot

# Generate USB image
generate_usb_image

# Mount USB image and copy files

# Clean up
rm "$DIR/cdroot/date.txt"
rm "$DIR/cdroot/system.zip"