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

if [ -d "$DIR/tmp" ]; then
  mkdir -p "$DIR/tmp"
  while IFS="" read -r p || [ -n "$p" ]; do
    # Split package name
    IFS="/" 
    read -a PACKAGE <<< "$p"
    echo "Downloading package: $p"
    curl --progress-bar -o "$DIR/tmp/${PACKAGE[1]}.zip" "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/$p.zip"
  done < "$DIR/packages.txt"
fi

# Save build date to CD

DATE="$(date)"
STR+=" Build Date: $DATE"
echo "$STR" > "$DIR/cdroot/date.txt"

# Generate ZIP file for installer

cd "$DIR/sysroot"
zip "$DIR/cdroot/system.zip" * -x *.md
cd "$DIR"

# Generate ISO

mkdir -p "$DIR/dist"
echo "Generating ISO..."
mkisofs -o "$DIR/dist/cobalt.iso" -publisher "$PUBLISHER" -V "$TITLE" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c boot.cat cdroot

# Clean up
rm "$DIR/cdroot/date.txt"
rm "$DIR/cdroot/system.zip"