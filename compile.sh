#!/bin/bash

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
    curl --progress-bar -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:96.0) Gecko/20100101 Firefox/96.0" -o "$DIR/tmp/${PACKAGE[1]}.zip" "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/repositories/latest/$p.zip"
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
  mkdir -p "$DIR/sysroot/system/bin"
  cp -f -r tmp/BIN/* sysroot/system/bin
}

DIR="$(pwd "${BASH_SOURCE[0]}")"
PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"
PARAM=$1

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

if [ "$PARAM" == "--force-rebuild" ]; then
  get_dependencies
elif ! [ -d "$DIR/tmp" ]; then
  get_dependencies
else
  echo "Dependencies already downloaded, skipping..."
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