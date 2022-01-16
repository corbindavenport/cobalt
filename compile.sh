#!/bin/bash

DIR="$(pwd "${BASH_SOURCE[0]}")"
PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"

cd "$DIR"

# Check for mkisofs

if ! [ -x "$(command -v mkisofs)" ]; then
  echo "Install mkisofs and run this script again."
  exit
fi

mkdir -p "$DIR/dist"

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