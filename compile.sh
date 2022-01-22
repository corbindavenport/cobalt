#!/bin/bash

DIR="$(pwd "${BASH_SOURCE[0]}")"
PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"

cd "$DIR"

# Check for prerequisites

if ! [ -x "$(command -v mkisofs)" ]; then
  echo "Install mkisofs and run this script again."
  exit
fi

if ! [ -x "$(command -v jq)" ]; then
  echo "Install jq and run this script again."
  echo "https://stedolan.github.io/jq/download/"
  exit
fi

mkdir -p "$DIR/dist"

# Download packages
# This is disabled for now, add a '!' after 'if' to test

if ! [ -d "$DIR/tmp" ]; then
  mkdir -p "$DIR/tmp"
  while IFS="" read -r p || [ -n "$p" ]; do
    # Split package name
    IFS="/" 
    read -a PACKAGE <<< "$p"
    # Download
    echo "Downloading package: $p"
    curl --progress-bar -o "$DIR/tmp/${PACKAGE[1]}.zip" "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/$p.zip"
    # Create single BIN folder from all zip files
    unzip -o "$DIR/tmp/${PACKAGE[1]}.zip" "BIN/*" "bin/*" -x "*/_*" "*/*.HLP" -d "$DIR/tmp/"
    # Create source folder
    unzip -o "$DIR/tmp/${PACKAGE[1]}.zip" "SOURCE/*" "source/*" -x "*/_*" -d "$DIR/tmp/"
  done < "$DIR/packages.txt"
  # Zip up combined source folder and move it to the CD
  cd "$DIR/tmp/SOURCE"
  zip -r "$DIR/cdroot/source.zip" *
  cd "$DIR"
  # Move binaries to system folder
  cp -f -r "$DIR/tmp/BIN" "$DIR/sysroot/system/bin"
fi

# Save build date to CD

DATE="$(date)"
STR+=" Build Date: $DATE"
echo "$STR" > "$DIR/cdroot/date.txt"

# Generate ZIP file for installer

cd "$DIR/sysroot"
zip -r "$DIR/cdroot/system.zip" * -x *.md
cd "$DIR"

# Generate ISO

mkdir -p "$DIR/dist"
echo "Generating ISO..."
mkisofs -o "$DIR/dist/cobalt.iso" -publisher "$PUBLISHER" -V "$TITLE" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c boot.cat cdroot

# Clean up
rm "$DIR/cdroot/date.txt"
rm "$DIR/cdroot/system.zip"