#!/bin/bash

PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"

# Check for mkisofs

if ! [ -x "$(command -v mkisofs)" ]; then
  echo "Install mkisofs and run this script again."
  exit
fi

mkdir -p "$PWD/dist"

# Save build date to CD

DATE="$(date)"
STR+=" Build Date: $DATE"
echo "$STR" > "$PWD/cdroot/date.txt"

# Generate ISO

mkdir -p "$PWD/dist"
echo "Generating ISO..."
mkisofs -o "$PWD/dist/cobalt.iso" -publisher "$PUBLISHER" -V "$TITLE" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c boot.cat cdroot

# Clean up
rm "$PWD/cdroot/date.txt"